module Api::V1
  class CompanyPagesController < ApplicationController
    before_action :set_company_page, only: [:show, :update, :destroy]
    before_action :authenticate_user!

    def check_public_url
      page = CompanyPage.find_by(:public_url=>params[:term])
      if page.present?
        render_unprocessable_entity( I18n.t('common.already_exist', model: 'Public URL') ,500)
      else
        render_processable_entity(I18n.t('common.not_exist', model: 'Public URL'),200)
      end
    end


    # GET /company_pages
    def index

      @company_pages = CompanyPage.paginate(page: params[:page], per_page: PAGE_COUNT)

      render_success_response({
                                  company_pages: array_serializer.new(@company_pages, serializer: CompanyPageSerializer)},'', 200, {
                                  pagination: SerializeHelper.pagination_dict(@company_pages)
                              })

    end

    # GET /company_pages/slug
    def show
      company_page_viewers= @company_page.company_page_viewers.find_or_create_by(:viewer_id=>current_user.id) if current_user.present? && current_user.id != @company_page.user_id
      render_success_response({
                                  company_page: single_serializer(@company_page, CompanyPageSerializer)
                              })
    end

    # POST /company_pages
    def create
      company_page_data=company_page_params
      company_page_data[:user_id]=current_user.id
      @company_page = CompanyPage.new(company_page_data)
      begin
      if @company_page.save
        @company_page.create_activity key: 'company_page.created', owner: current_user
        render_success_response({
                                    company_page: single_serializer(@company_page, CompanyPageSerializer)
                                }, I18n.t('common.created', model: 'CompanyPage'))
      else
        render_unprocessable_entity_response(@company_page)
      end
      rescue ActiveRecord::RecordNotUnique=>ex
        render_unprocessable_entity("Public URL already exist",500)
      end
    end

    # PATCH/PUT /company_pages/slug
    def update
      # company_page_hashtags_ids=@company_page.company_page_hashtags.ids
      if @company_page.update(company_page_params)
        # PageHashtag.delete(company_page_hashtags_ids)
        # @company_page.create_activity key: 'company_page.updated', owner: current_user
        render_success_response({
                                    company_page: single_serializer(@company_page, CompanyPageSerializer)
                                }, I18n.t('common.updated', model: 'CompanyPage'))
      else
        render_unprocessable_entity_response(@company_page)
      end
    end

    # DELETE /company_pages/slug
    def destroy
      @company_page.destroy
      @activity = PublicActivity::Activity.where(trackable_id: @company_page.id, trackable_type: "CompanyPage")
      @activity.destroy_all
      render_success_response({
                                  company_page: single_serializer(@company_page, CompanyPageSerializer)
                              }, I18n.t('common.deleted', model: 'CompanyPage'))
    end

    # POST /company_pages/:company_page_slug/like_dislike
    def like_dislike
      company_page=CompanyPage.find_by(:slug=>params[:company_page_slug])
      if company_page.present?
        @company_page_like  = PageLike.find_by(:user_id => current_user.id, :company_page_id => company_page.id)
        @company_page_likes = PageLike.where(:company_page_id => company_page.id).paginate(page: params[:page], per_page: PAGE_COUNT)
      end
      if @company_page_like.present?
        if PageLike.destroy(@company_page_like.id)
          # company_page.create_activity key: 'company_page.liked', owner: current_user
          @activity = PublicActivity::Activity.find_by(key: 'company_page.liked',owner_id: current_user.id,trackable_id: company_page.id, trackable_type: "CompanyPage")
          @activity.destroy
          render_success_response({
                                      company_page_likes: array_serializer.new(@company_page_likes, serializer: CompanyPageLikeSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@company_page_likes)
                                  })
        else
          render_unprocessable_entity_response(@company_page_like)
        end
      else
        @company_page_like = PageLike.new(:user_id => current_user.id, :company_page_id => company_page.id)
        if @company_page_like.save
          company_page.create_activity key: 'company_page.liked', owner: current_user
          render_success_response({
                                      company_page_likes: array_serializer.new(@company_page_likes, serializer: CompanyPageLikeSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@company_page_likes)
                                  })
        else
          render_unprocessable_entity_response(@company_page_like)
        end
      end
    end

    # POST /company_pages/:company_page_slug/share
    def share
      company_page=CompanyPage.find_by(:slug=>params[:company_page_slug])
      if company_page.present?
        company_page.create_activity key: 'company_page.shared', owner: current_user
        @company_page_share  = PageShare.find_by(:user_id => current_user.id, :company_page_id => company_page.id)
        @company_page_shares = PageShare.where(:company_page_id => company_page.id).paginate(page: params[:page], per_page: PAGE_COUNT)
      end
      # unless @company_page_share.present?
        @company_page_share = PageShare.new(:user_id => current_user.id, :company_page_id => company_page.id)
        if @company_page_share.save
          render_success_response({
                                      company_page_shares: array_serializer.new(@company_page_shares, serializer: CompanyPageShareSerializer)},'', 200, {
                                      pagination: SerializeHelper.pagination_dict(@company_page_shares)
                                  })
        else
          render_unprocessable_entity_response(@company_page_share)
        end
      # else
      #   render json: @company_page_shares
      # end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_company_page
      @company_page = CompanyPage.find_by(:slug=>params[:slug])
      unless @company_page.present?
        render_unprocessable_entity(I18n.t('common.not_fount', model: 'CompanyPage'))
      end
    end

    # Only allow a trusted parameter "white list" through.
    def company_page_params
      # params.fetch(:company_page, {})
      params.require(:company_page).permit(:id, :profile_image, :cover_image, :page_identity, :tagline, :public_url, :website, :industry, :company_size, :street, :address, :zip_code, :year_of_establishment, :company_type, :user_id)
    end

  end
end
