module ApplicationHelper

  def active_class_for(span)
    return (span.eql?('week')) ? 'active' : '' if params[:span].blank?
    return params[:span].eql?(span) ? 'active' : ''
  end

end
