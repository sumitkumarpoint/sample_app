# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application
# use OmniAuth::Builder do
#   provider :azure_activedirectory, "aab3d5b8-9076-4b85-a522-7e79a42cb88b", "f8cdef31-a31e-4b4a-93e4-5f571e91255a"
# end