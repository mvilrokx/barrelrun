$ -> 
  breadcrumb = $("<ul class='better-breadcrumb'></ul>")
  navigation = "<span class='div_texbox nav_links'><span>"
  fieldsets = new Array()
  fs_name = new Array()

  form = $(".crumbify")
  form.prepend(breadcrumb)

  parseFieldset = (position, fieldset) -> 
    switch position
      when 0  #first fieldset
        $('.nav_links', fieldset).append("<a href='#' class='next button'>" + fs_name[i+1] + " ></a>")
        $('#breadcrumb_step_' + i, form).addClass('first visited')        
      when fieldsets.length-1  # Last fieldset
        fieldset.hide()
        $('.nav_links', fieldset).append("<a href='#' class='prev button'>< " + fs_name[i-1] + "</a>&nbsp;<a href='#' class='review button'>Review ></a>")        
      else # all other fieldsets
        fieldset.hide()
        $('.nav_links', fieldset).append("<a href='#' class='prev button'>< " + fs_name[i-1] + "</a>&nbsp;<a href='#' class='next button'>" + fs_name[i+1] + " ></a>")  

  $("fieldset", form).each((i) -> 
    fieldsets[i] = $(this)
    fieldsets[i].attr('id', 'step' + i)
    fs_name[i] = fieldsets[i].find('legend').text()
    fieldsets[i].find('legend').hide()
    fieldsets[i].append(navigation)
    $('.better-breadcrumb', form).append("<li id='breadcrumb_step_" + i + "'>" + fs_name[i] + "</li>")
  )

  $('.better-breadcrumb', form).append("<li class='last' id='breadcrumb_step_" + fieldsets.length + "'>Review</li>")
  # hide the submit button, it will be reveiled on the review page
  $('input[type="submit"]', form).hide()

  parseFieldset i, fieldset for fieldset, i in fieldsets

  $(".next", form).live('click', ->
    current_fieldset = $(this)
    current_fieldset.closest('fieldset').hide('slide', ->
      current_fieldset.parents('fieldset:first').next('fieldset').show('slide', { direction: "right" })
    )
    $(".better-breadcrumb li.visited:last").next().addClass("visited")
  )

  $(".prev", form).live('click', ->
    current_fieldset = $(this)
    $(this).closest('fieldset').hide('slide', { direction: "right" }, ->
      current_fieldset.parents('fieldset:first').prev('fieldset').show('slide')
    )
    $(".better-breadcrumb li.visited:last").removeClass("visited")
  )

  $(".review").live('click', ->
    $("fieldset", form).each((i) -> 
      $(this).show()
    )
    $('.nav_links').hide()
    $('legend').show()
    $('input[type="submit"]', form).show()
    $(".better-breadcrumb li.visited:last").next().addClass("visited")
    form.show('slide', { direction: "right" })
  )