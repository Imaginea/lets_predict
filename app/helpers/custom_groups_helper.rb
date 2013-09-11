module CustomGroupsHelper
  # Let's append tournament_id to the all routes for custom_groups
  def url_for(options = {})
    options ||= {}
    case options
    when String
      options
    when Hash
      options = options.symbolize_keys.reverse_merge!(:only_path => options[:host].nil?)
      options[:tournament_id] ||= @current_tournament.id if @current_tournament
      super
    when :back
      controller.request.env["HTTP_REFERER"] || 'javascript:history.back()'
    else
      polymorphic_path(options)
    end
  end
end
