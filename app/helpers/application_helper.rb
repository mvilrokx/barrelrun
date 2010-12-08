# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Method used to add a title to each page
  def title(page_title)
    content_for(:title) { page_title }
  end

  def link_with_active(text, url)
    if url == "/" then
       if request.request_uri == "/" then
         return link_to text, url, :id => "selected_main_tab"
       else
         return link_to text, url
       end
    else           
       if request.request_uri.include? url then
         return link_to text, url, :id => "selected_main_tab"
       else
         return link_to text, url
       end
    end
  end

  def new_child_fields_template(form_builder, association, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:form_builder_local] ||= :f

    content_for :jstemplates do
      content_tag(:div, :id => "#{association}_fields_template", :style => "display: none") do
        form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|        
          render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })        
        end
      end
    end
  end

  def add_child_link(name, association)
    link_to(name, "javascript:void(0)", :class => "add_child", :"data-association" => association)
  end

  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to(name, "javascript:void(0)", :class => "remove_child")
  end

#  def render_stars (rating = 0, read_only = false)
  def render_stars (object_to_star, read_only = false, rate = nil)
#    field_set_tag nil, :class=> "stars" do
      if object_to_star then
        rating = object_to_star.average_rating||0
      else
        rating = rate
      end
      (1..10).map do |i|
#        if object_to_rate.average_rating
          if rating.round == i
            radio_button_tag "rating", i, true, :disabled => read_only
          else    
            radio_button_tag "rating", i, false, :disabled => read_only
          end
#        end
      end.join
#    end
  end

  def render_stars_from_rate (rating = 0)
    print "entering render_stars_from_rate!!!!!!!!!!!!!!!!!!!!!"
    (1..10).map do |i|
      if rating.round == i
        radio_button_tag "rating", i, true, :disabled => read_only
      else    
        radio_button_tag "rating", i, false, :disabled => read_only
      end
    end
    print "leaving render_stars_from_rate!!!!!!!!!!!!!!!!!!!!!"
  end

end


