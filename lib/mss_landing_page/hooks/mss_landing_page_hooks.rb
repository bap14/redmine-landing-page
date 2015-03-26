module MssLandingPage
    module Hooks
        class RedmineCategoryTreeHooks < Redmine::Hook::ViewListener
            def controller_account_success_authentication_after(context={})
                @request = context[:request]
                @params = context[:controller].params

                baseRegex = /#{@request.scheme}:\/\/#{Regexp.escape(@request.host)}(:#{@request.port})?\/(?!login|logout)?/i

                query_params = Setting.plugin_mss_landing_page['query_params']
                project_id = Setting.plugin_mss_landing_page['project_id']

                back_url = @params[:back_url].to_s
                if !back_url.present? || !baseRegex.match(back_url).nil?
                    if !project_id.nil?
                        redirTo = "#{@request.scheme}://#{@request.host_with_port}/projects/#{project_id}/issues"

                        if !query_params.nil?
                            redirTo << "?#{query_params}"
                        end

                        context[:controller].params[:back_url] = redirTo
                    end
                end
            end
        end
    end
end