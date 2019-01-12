module ApplicationHelper

  def active_class_for(span)
    return (span.eql?('week')) ? 'button active' : 'button' if params[:span].blank?
    return params[:span].eql?(span) ? 'button active' : 'button'
  end

end
