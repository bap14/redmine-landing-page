require_dependency 'account_controller'

module MssLandingPageAccountControllerPatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		base.class_eval do
			# creates 2 new methods: #{param1}_with_#{param2} and #{param1}_without_#{param2}
			# where the latter is the original method
			logger.info "Aliasing the methods ..."
			alias_method_chain :successful_authentication, :redirect_to_landing_page
		end
	end

	module InstanceMethods
		def successful_authentication_with_redirect_to_landing_page(default)
			baseRegex = /#{request.scheme}:\/\/#{Regexp.escape(request.host)}(:#{request.port})?\/?/i

			query_params = Setting.plugin_mss_landing_page['query_params']
			project_id = Setting.plugin_mss_landing_page['project_id']

			back_url = params[:back_url].to_s
			if !back_url.present? || !baseRegex.match(back_url).nil?
				if !project_id.nil?
					redirTo = "#{request.scheme}://#{request.host_with_port}/projects/#{project_id}/issues"

					if !query_params.nil?
						redirTo << "?#{query_params}"
					end

					logger.info "-- Updating back_url to be #{redirTo}"

					request[:back_url] = redirTo
				end
			end

			return successful_authentication_without_redirect_to_landing_page(default)
		end
	end

	# Here because internal calls to this method apparently don't get mapped
	def successful_authentication(default)
		successful_authentication_with_redirect_to_landing_page(default)
	end
end

AccountController.send(:include, MssLandingPageAccountControllerPatch)