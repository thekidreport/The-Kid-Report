# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def browser
		unless @browser
			agent = request.env['HTTP_USER_AGENT'] || ""
			if agent.include?('MSIE 6.0')
				@browser = :ie6
			elsif agent.include?('MSIE 5.0')
				@browser = :ie5
			elsif agent.include?('MSIE 7.0')
				@browser = :ie7
			elsif agent.include?('Firefox')
				@browser = :firefox
			elsif agent.include?('Safari')
				@browser = :safari
			elsif agent.include?('Opera')
				@browser = :opera
			else
				@browser = :unknown
			end
		end
		return @browser
	end

  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end
  
end
