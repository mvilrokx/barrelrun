module ApplicationHelper
  # Method used to add a title to each page
  def title(page_title)
    content_for(:title, page_title.to_s)
  end

  # Methods to add icons to links
  def link_image(link, image, text, *args)
    options = args.extract_options!
    link_to image_tag(image, :border=>0, :alt=>text), link, :title=> text, :class => options[:class]
  end

  def show_link_image(link, *args)
    link_image(link, "icons/page_find.png", "Show", *args)
  end

  def edit_link_image(link, *args)
    link_image(link, "icons/page_edit.png", "Edit", *args)
  end

  def delete_link_image(link, *args)
    link_image(link, "icons/bin_closed.png", "Delete", *args)
  end

  # Method used to determine which tab is active
  def link_with_active(text, url)
    if url == "/" then
       if request.fullpath == "/" then
         return link_to text, url, :id => "selected_main_tab"
       else
         return link_to text, url
       end
    else
       if request.fullpath.include? url then
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
#      (1..10).map do |i|
      [0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5].map do |i|
#        if object_to_rate.average_rating
          if ((rating*2).round)/2.to_f == i
            radio_button_tag "rating", i, true, :disabled => read_only
          else
            radio_button_tag "rating", i, false, :disabled => read_only
          end
#        end
      end.join.html_safe
#    end
  end

#  def render_stars_from_rate (rating = 0)
#    (1..10).map do |i|
#      if rating.round == i
#        radio_button_tag "rating", i, true, :disabled => read_only
#      else
#        radio_button_tag "rating", i, false, :disabled => read_only
#      end
#    end
#  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_asc_or_desc}" : nil
    direction = column == sort_column && sort_asc_or_desc == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :asc_or_desc => direction}, {:class => css_class}
  end

  def pretty_seconds(sec)
    "%02d:%02d" % [ (sec/60).floor, (sec - ((sec/60).floor * 60)).round ]
  end

end

