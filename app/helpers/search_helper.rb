module SearchHelper
  
  def order(name, options = {})
    options[:as] ||= name.capitalize
    name = name.to_sym
    link_to options[:as], url_for(:order => params[:order] == "#{name} asc" ? "#{name} desc" : "#{name} asc")
  end
  
end