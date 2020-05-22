class Credential

  class << self

    def env attr
      val = Rails.application.credentials.dig(Rails.env.to_sym, attr.to_sym)
      if val
        val
      else
        Rails.application.credentials.dig(attr.to_sym)
      end
    end

  end

end
