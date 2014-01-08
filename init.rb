require 'redmine'
require 'mss_landing_page_account_controller_patch'

Redmine::Plugin.register :mss_landing_page do
	name 'MSS Landing Page'
	author 'Brett Patterson'
	description 'Force users upon login to a specific landing page'
	version '0.0.2'

	settings :default => {'empty' => true}, :partial => 'settings/mss_landing_page'

	requires_redmine :version_or_higher => '2.0.3'
end