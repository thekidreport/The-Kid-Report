# PickyColor
module PickyColor
  module FormHelper
    
    # Gather the picky_color related options and set them to another hash
    # set defaults values if related options aren't set by the user
    def picky_color_process_options(options)
      picky_options = {}
      for key in [:draggable, :close_text, :style_color_well, :default]
        picky_options[key] = options.delete(key) if options.has_key?(key)
      end
      
      picky_options[:draggable] ||= false
      picky_options[:close_text] ||= 'OK'
      picky_options[:default] ||= "000000"
      
      return picky_options     
    end
    
    
    # include to the output the span and javascript tag needed for the helper
    def picky_color_output(input, object_name, method, id, picky_options = {})
      name = method.nil? ? "#{id}" : "#{object_name_to_id(object_name)}_#{method}".gsub("__","_")

      color_well_id = "color_well_#{name}"
      out = input
      out << content_tag(:span, :id => color_well_id, :class => "color-picker-box") do end
      
      out << (javascript_tag %{
      color_value = $('#{name}').value
      if (color_value == "") {
        color_value = "#{picky_options[:default]}"
      }
      new PickyColor({
          color: color_value,
          field: '#{name}',
          colorWell: '#{color_well_id}',
          draggable: #{picky_options[:draggable]},
          closeText: '#{picky_options[:close_text]}',
          imageBase: '/images/picky_color/'
         })}) 
             
      return out    
    end
    
    
    def picky_color_tag(name, value = nil, options = {})
      picky_options = picky_color_process_options options
      options[:id] ||= name
    
      
      input = tag :input, {"type" => "text", 
                   "id" => options[:id], 
                   "name" => name,
                   "value" => value}.update(options.stringify_keys)

      return picky_color_output(input, name, nil, options[:id], picky_options)
    end

            
    def picky_color(object_name, method, options = {})     
      obj = options[:object] || instance_variable_get("@#{object_name}")
      picky_options = picky_color_process_options options


      # to keep it working with old rails versions:
      begin
        input = ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object))
      rescue ArgumentError
        input = ActionView::Helpers::InstanceTag.new(object_name, method, self, nil, options.delete(:object))
      end
      return picky_color_output input.to_input_field_tag("text", options), object_name, method, nil, picky_options   
    end

    private
    def object_name_to_id(name)
      name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
    end
    
  end
end

module ActionView
  module Helpers
    class FormBuilder
      def picky_color(method, options = {})
        @template.picky_color(@object_name, method, options.merge(:object => @object))
      end
    end
  end
end