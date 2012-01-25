(function( $ ){
    $.fn.HGForm = function() {
  
        var span_start = "<span class='div_texbox'>";
        var span_end = "</span>";
        var prev = "<a href='#' class='prev'>< Back</a>";
        var next = "<a href='#' class='next'>Next ></a>";
        var breadcrum = "<ul class='breadcrumb'>";

        this.find('fieldset').each(function(i) {
            var $this = $(this);
            $this.find('legend').hide();
            if (i != 0) {
                $this.hide();
                if (i == $(this).size()-1) {
                    $this.append(span_start + prev + span_end);
                    breadcrum = breadcrum + "<li class='last'>" + $this.find('legend').html() + "</li>";
                } else {
                    $this.append(span_start + prev + " | " + next + span_end);        
                    breadcrum = breadcrum + "<li>" + $this.find('legend').html() + "</li>";
                };
            } else {
                $this.append(span_start + next + span_end);        
                breadcrum = breadcrum + "<li class='first visited'>" + $this.find('legend').html() + "</li>";
            };        
        });
        
        breadcrum = breadcrum + "</ul>";
        this.prepend(breadcrum);
            
        $(".next").live('click', function(){
            current_fieldset = $(this)
            $(this).closest('fieldset').hide('slide', function(){
                current_fieldset.parents('fieldset:first').next('fieldset').show('slide', { direction: "right" });
            });
            $(".breadcrumb li.visited:last").next().addClass("visited");
        });

        $(".prev").live('click', function(){
            current_fieldset = $(this)
            $(this).closest('fieldset').hide('slide', { direction: "right" }, function(){
              current_fieldset.parents('fieldset:first').prev('fieldset').show('slide');
            });
            $(".breadcrumb li.visited:last").removeClass("visited");
        });
    };
})( jQuery );
(function($, undefined) {

/**
 * Unobtrusive scripting adapter for jQuery
 *
 * Requires jQuery 1.6.0 or later.
 * https://github.com/rails/jquery-ujs

 * Uploading file using rails.js
 * =============================
 *
 * By default, browsers do not allow files to be uploaded via AJAX. As a result, if there are any non-blank file fields
 * in the remote form, this adapter aborts the AJAX submission and allows the form to submit through standard means.
 *
 * The `ajax:aborted:file` event allows you to bind your own handler to process the form submission however you wish.
 *
 * Ex:
 *     $('form').live('ajax:aborted:file', function(event, elements){
 *       // Implement own remote file-transfer handler here for non-blank file inputs passed in `elements`.
 *       // Returning false in this handler tells rails.js to disallow standard form submission
 *       return false;
 *     });
 *
 * The `ajax:aborted:file` event is fired when a file-type input is detected with a non-blank value.
 *
 * Third-party tools can use this hook to detect when an AJAX file upload is attempted, and then use
 * techniques like the iframe method to upload the file instead.
 *
 * Required fields in rails.js
 * ===========================
 *
 * If any blank required inputs (required="required") are detected in the remote form, the whole form submission
 * is canceled. Note that this is unlike file inputs, which still allow standard (non-AJAX) form submission.
 *
 * The `ajax:aborted:required` event allows you to bind your own handler to inform the user of blank required inputs.
 *
 * !! Note that Opera does not fire the form's submit event if there are blank required inputs, so this event may never
 *    get fired in Opera. This event is what causes other browsers to exhibit the same submit-aborting behavior.
 *
 * Ex:
 *     $('form').live('ajax:aborted:required', function(event, elements){
 *       // Returning false in this handler tells rails.js to submit the form anyway.
 *       // The blank required inputs are passed to this function in `elements`.
 *       return ! confirm("Would you like to submit the form with missing info?");
 *     });
 */

  // Shorthand to make it a little easier to call public rails functions from within rails.js
  var rails;

  $.rails = rails = {
    // Link elements bound by jquery-ujs
    linkClickSelector: 'a[data-confirm], a[data-method], a[data-remote], a[data-disable-with]',

    // Select elements bound by jquery-ujs
    inputChangeSelector: 'select[data-remote], input[data-remote], textarea[data-remote]',

    // Form elements bound by jquery-ujs
    formSubmitSelector: 'form',

    // Form input elements bound by jquery-ujs
    formInputClickSelector: 'form input[type=submit], form input[type=image], form button[type=submit], form button:not(button[type])',

    // Form input elements disabled during form submission
    disableSelector: 'input[data-disable-with], button[data-disable-with], textarea[data-disable-with]',

    // Form input elements re-enabled after form submission
    enableSelector: 'input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled',

    // Form required input elements
    requiredInputSelector: 'input[name][required]:not([disabled]),textarea[name][required]:not([disabled])',

    // Form file input elements
    fileInputSelector: 'input:file',

    // Link onClick disable selector with possible reenable after remote submission
    linkDisableSelector: 'a[data-disable-with]',

    // Make sure that every Ajax request sends the CSRF token
    CSRFProtection: function(xhr) {
      var token = $('meta[name="csrf-token"]').attr('content');
      if (token) xhr.setRequestHeader('X-CSRF-Token', token);
    },

    // Triggers an event on an element and returns false if the event result is false
    fire: function(obj, name, data) {
      var event = $.Event(name);
      obj.trigger(event, data);
      return event.result !== false;
    },

    // Default confirm dialog, may be overridden with custom confirm dialog in $.rails.confirm
    confirm: function(message) {
      return confirm(message);
    },

    // Default ajax function, may be overridden with custom function in $.rails.ajax
    ajax: function(options) {
      return $.ajax(options);
    },

    // Submits "remote" forms and links with ajax
    handleRemote: function(element) {
      var method, url, data,
        crossDomain = element.data('cross-domain') || null,
        dataType = element.data('type') || ($.ajaxSettings && $.ajaxSettings.dataType),
        options;

      if (rails.fire(element, 'ajax:before')) {

        if (element.is('form')) {
          method = element.attr('method');
          url = element.attr('action');
          data = element.serializeArray();
          // memoized value from clicked submit button
          var button = element.data('ujs:submit-button');
          if (button) {
            data.push(button);
            element.data('ujs:submit-button', null);
          }
        } else if (element.is(rails.inputChangeSelector)) {
          method = element.data('method');
          url = element.data('url');
          data = element.serialize();
          if (element.data('params')) data = data + "&" + element.data('params');
        } else {
          method = element.data('method');
          url = element.attr('href');
          data = element.data('params') || null;
        }

        options = {
          type: method || 'GET', data: data, dataType: dataType, crossDomain: crossDomain,
          // stopping the "ajax:beforeSend" event will cancel the ajax request
          beforeSend: function(xhr, settings) {
            if (settings.dataType === undefined) {
              xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
            }
            return rails.fire(element, 'ajax:beforeSend', [xhr, settings]);
          },
          success: function(data, status, xhr) {
            element.trigger('ajax:success', [data, status, xhr]);
          },
          complete: function(xhr, status) {
            element.trigger('ajax:complete', [xhr, status]);
          },
          error: function(xhr, status, error) {
            element.trigger('ajax:error', [xhr, status, error]);
          }
        };
        // Only pass url to `ajax` options if not blank
        if (url) { options.url = url; }

        return rails.ajax(options);
      } else {
        return false;
      }
    },

    // Handles "data-method" on links such as:
    // <a href="/users/5" data-method="delete" rel="nofollow" data-confirm="Are you sure?">Delete</a>
    handleMethod: function(link) {
      var href = link.attr('href'),
        method = link.data('method'),
        target = link.attr('target'),
        csrf_token = $('meta[name=csrf-token]').attr('content'),
        csrf_param = $('meta[name=csrf-param]').attr('content'),
        form = $('<form method="post" action="' + href + '"></form>'),
        metadata_input = '<input name="_method" value="' + method + '" type="hidden" />';

      if (csrf_param !== undefined && csrf_token !== undefined) {
        metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />';
      }

      if (target) { form.attr('target', target); }

      form.hide().append(metadata_input).appendTo('body');
      form.submit();
    },

    /* Disables form elements:
      - Caches element value in 'ujs:enable-with' data store
      - Replaces element text with value of 'data-disable-with' attribute
      - Sets disabled property to true
    */
    disableFormElements: function(form) {
      form.find(rails.disableSelector).each(function() {
        var element = $(this), method = element.is('button') ? 'html' : 'val';
        element.data('ujs:enable-with', element[method]());
        element[method](element.data('disable-with'));
        element.prop('disabled', true);
      });
    },

    /* Re-enables disabled form elements:
      - Replaces element text with cached value from 'ujs:enable-with' data store (created in `disableFormElements`)
      - Sets disabled property to false
    */
    enableFormElements: function(form) {
      form.find(rails.enableSelector).each(function() {
        var element = $(this), method = element.is('button') ? 'html' : 'val';
        if (element.data('ujs:enable-with')) element[method](element.data('ujs:enable-with'));
        element.prop('disabled', false);
      });
    },

   /* For 'data-confirm' attribute:
      - Fires `confirm` event
      - Shows the confirmation dialog
      - Fires the `confirm:complete` event

      Returns `true` if no function stops the chain and user chose yes; `false` otherwise.
      Attaching a handler to the element's `confirm` event that returns a `falsy` value cancels the confirmation dialog.
      Attaching a handler to the element's `confirm:complete` event that returns a `falsy` value makes this function
      return false. The `confirm:complete` event is fired whether or not the user answered true or false to the dialog.
   */
    allowAction: function(element) {
      var message = element.data('confirm'),
          answer = false, callback;
      if (!message) { return true; }

      if (rails.fire(element, 'confirm')) {
        answer = rails.confirm(message);
        callback = rails.fire(element, 'confirm:complete', [answer]);
      }
      return answer && callback;
    },

    // Helper function which checks for blank inputs in a form that match the specified CSS selector
    blankInputs: function(form, specifiedSelector, nonBlank) {
      var inputs = $(), input,
        selector = specifiedSelector || 'input,textarea';
      form.find(selector).each(function() {
        input = $(this);
        // Collect non-blank inputs if nonBlank option is true, otherwise, collect blank inputs
        if (nonBlank ? input.val() : !input.val()) {
          inputs = inputs.add(input);
        }
      });
      return inputs.length ? inputs : false;
    },

    // Helper function which checks for non-blank inputs in a form that match the specified CSS selector
    nonBlankInputs: function(form, specifiedSelector) {
      return rails.blankInputs(form, specifiedSelector, true); // true specifies nonBlank
    },

    // Helper function, needed to provide consistent behavior in IE
    stopEverything: function(e) {
      $(e.target).trigger('ujs:everythingStopped');
      e.stopImmediatePropagation();
      return false;
    },

    // find all the submit events directly bound to the form and
    // manually invoke them. If anyone returns false then stop the loop
    callFormSubmitBindings: function(form, event) {
      var events = form.data('events'), continuePropagation = true;
      if (events !== undefined && events['submit'] !== undefined) {
        $.each(events['submit'], function(i, obj){
          if (typeof obj.handler === 'function') return continuePropagation = obj.handler(event);
        });
      }
      return continuePropagation;
    },

    //  replace element's html with the 'data-disable-with' after storing original html
    //  and prevent clicking on it
    disableElement: function(element) {
      element.data('ujs:enable-with', element.html()); // store enabled state
      element.html(element.data('disable-with')); // set to disabled state
      element.bind('click.railsDisable', function(e) { // prevent further clicking
        return rails.stopEverything(e)
      });
    },

    // restore element to its original state which was disabled by 'disableElement' above
    enableElement: function(element) {
      if (element.data('ujs:enable-with') !== undefined) {
        element.html(element.data('ujs:enable-with')); // set to old enabled state
        // this should be element.removeData('ujs:enable-with')
        // but, there is currently a bug in jquery which makes hyphenated data attributes not get removed
        element.data('ujs:enable-with', false); // clean up cache
      }
      element.unbind('click.railsDisable'); // enable element
    }

  };

  $.ajaxPrefilter(function(options, originalOptions, xhr){ if ( !options.crossDomain ) { rails.CSRFProtection(xhr); }});

  $(document).delegate(rails.linkDisableSelector, 'ajax:complete', function() {
      rails.enableElement($(this));
  });

  $(document).delegate(rails.linkClickSelector, 'click.rails', function(e) {
    var link = $(this), method = link.data('method'), data = link.data('params');
    if (!rails.allowAction(link)) return rails.stopEverything(e);

    if (link.is(rails.linkDisableSelector)) rails.disableElement(link);

    if (link.data('remote') !== undefined) {
      if ( (e.metaKey || e.ctrlKey) && (!method || method === 'GET') && !data ) { return true; }

      if (rails.handleRemote(link) === false) { rails.enableElement(link); }
      return false;

    } else if (link.data('method')) {
      rails.handleMethod(link);
      return false;
    }
  });

  $(document).delegate(rails.inputChangeSelector, 'change.rails', function(e) {
    var link = $(this);
    if (!rails.allowAction(link)) return rails.stopEverything(e);

    rails.handleRemote(link);
    return false;
  });

  $(document).delegate(rails.formSubmitSelector, 'submit.rails', function(e) {
    var form = $(this),
      remote = form.data('remote') !== undefined,
      blankRequiredInputs = rails.blankInputs(form, rails.requiredInputSelector),
      nonBlankFileInputs = rails.nonBlankInputs(form, rails.fileInputSelector);

    if (!rails.allowAction(form)) return rails.stopEverything(e);

    // skip other logic when required values are missing or file upload is present
    if (blankRequiredInputs && form.attr("novalidate") == undefined && rails.fire(form, 'ajax:aborted:required', [blankRequiredInputs])) {
      return rails.stopEverything(e);
    }

    if (remote) {
      if (nonBlankFileInputs) {
        return rails.fire(form, 'ajax:aborted:file', [nonBlankFileInputs]);
      }

      // If browser does not support submit bubbling, then this live-binding will be called before direct
      // bindings. Therefore, we should directly call any direct bindings before remotely submitting form.
      if (!$.support.submitBubbles && $().jquery < '1.7' && rails.callFormSubmitBindings(form, e) === false) return rails.stopEverything(e);

      rails.handleRemote(form);
      return false;

    } else {
      // slight timeout so that the submit button gets properly serialized
      setTimeout(function(){ rails.disableFormElements(form); }, 13);
    }
  });

  $(document).delegate(rails.formInputClickSelector, 'click.rails', function(event) {
    var button = $(this);

    if (!rails.allowAction(button)) return rails.stopEverything(event);

    // register the pressed submit button
    var name = button.attr('name'),
      data = name ? {name:name, value:button.val()} : null;

    button.closest('form').data('ujs:submit-button', data);
  });

  $(document).delegate(rails.formSubmitSelector, 'ajax:beforeSend.rails', function(event) {
    if (this == event.target) rails.disableFormElements($(this));
  });

  $(document).delegate(rails.formSubmitSelector, 'ajax:complete.rails', function(event) {
    if (this == event.target) rails.enableFormElements($(this));
  });

})( jQuery );
/* ------------------------------------------------------------------------
	Class: prettyPhoto
	Use: Lightbox clone for jQuery
	Author: Stephane Caron (http://www.no-margin-for-errors.com)
	Version: 3.0.1
------------------------------------------------------------------------- */


(function($) {
	$.prettyPhoto = {version: '3.0'};
	
	$.fn.prettyPhoto = function(pp_settings) {
		pp_settings = jQuery.extend({
			animation_speed: 'fast', /* fast/slow/normal */
			slideshow: false, /* false OR interval time in ms */
			autoplay_slideshow: false, /* true/false */
			opacity: 0.80, /* Value between 0 and 1 */
			show_title: true, /* true/false */
			allow_resize: true, /* Resize the photos bigger than viewport. true/false */
			default_width: 500,
			default_height: 344,
			counter_separator_label: '/', /* The separator for the gallery counter 1 "of" 2 */
			theme: 'facebook', /* light_rounded / dark_rounded / light_square / dark_square / facebook */
			hideflash: false, /* Hides all the flash object on a page, set to TRUE if flash appears over prettyPhoto */
			wmode: 'opaque', /* Set the flash wmode attribute */
			autoplay: true, /* Automatically start videos: True/False */
			modal: false, /* If set to true, only the close button will close the window */
			overlay_gallery: true, /* If set to true, a gallery will overlay the fullscreen image on mouse over */
			keyboard_shortcuts: true, /* Set to false if you open forms inside prettyPhoto */
			changepicturecallback: function(){}, /* Called everytime an item is shown/changed */
			callback: function(){}, /* Called when prettyPhoto is closed */
			markup: '<div class="pp_pic_holder"> \
						<div class="ppt">&nbsp;</div> \
						<div class="pp_top"> \
							<div class="pp_left"></div> \
							<div class="pp_middle"></div> \
							<div class="pp_right"></div> \
						</div> \
						<div class="pp_content_container"> \
							<div class="pp_left"> \
							<div class="pp_right"> \
								<div class="pp_content"> \
									<div class="pp_loaderIcon"></div> \
									<div class="pp_fade"> \
										<a href="#" class="pp_expand" title="Expand the image">Expand</a> \
										<div class="pp_hoverContainer"> \
											<a class="pp_next" href="#">next</a> \
											<a class="pp_previous" href="#">previous</a> \
										</div> \
										<div id="pp_full_res"></div> \
										<div class="pp_details clearfix"> \
											<p class="pp_description"></p> \
											<a class="pp_close" href="#">Close</a> \
											<div class="pp_nav"> \
												<a href="#" class="pp_arrow_previous">Previous</a> \
												<p class="currentTextHolder">0/0</p> \
												<a href="#" class="pp_arrow_next">Next</a> \
											</div> \
										</div> \
									</div> \
								</div> \
							</div> \
							</div> \
						</div> \
						<div class="pp_bottom"> \
							<div class="pp_left"></div> \
							<div class="pp_middle"></div> \
							<div class="pp_right"></div> \
						</div> \
					</div> \
					<div class="pp_overlay"></div>',
			gallery_markup: '<div class="pp_gallery"> \
								<a href="#" class="pp_arrow_previous">Previous</a> \
								<ul> \
									{gallery} \
								</ul> \
								<a href="#" class="pp_arrow_next">Next</a> \
							</div>',
			image_markup: '<img id="fullResImage" src="" />',
			flash_markup: '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="{width}" height="{height}"><param name="wmode" value="{wmode}" /><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="movie" value="{path}" /><embed src="{path}" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="{width}" height="{height}" wmode="{wmode}"></embed></object>',
			quicktime_markup: '<object classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab" height="{height}" width="{width}"><param name="src" value="{path}"><param name="autoplay" value="{autoplay}"><param name="type" value="video/quicktime"><embed src="{path}" height="{height}" width="{width}" autoplay="{autoplay}" type="video/quicktime" pluginspage="http://www.apple.com/quicktime/download/"></embed></object>',
			iframe_markup: '<iframe src ="{path}" width="{width}" height="{height}" frameborder="no"></iframe>',
			inline_markup: '<div class="pp_inline clearfix">{content}</div>',
			custom_markup: ''
		}, pp_settings);
		
		// Global variables accessible only by prettyPhoto
		var matchedObjects = this, percentBased = false, correctSizes, pp_open,
		
		// prettyPhoto container specific
		pp_contentHeight, pp_contentWidth, pp_containerHeight, pp_containerWidth,
		
		// Window size
		windowHeight = $(window).height(), windowWidth = $(window).width(),

		// Global elements
		pp_slideshow;
		
		doresize = true, scroll_pos = _get_scroll();
	
		// Window/Keyboard events
		$(window).unbind('resize').resize(function(){ _center_overlay(); _resize_overlay(); });
		
		if(pp_settings.keyboard_shortcuts) {
			$(document).unbind('keydown').keydown(function(e){
				if(typeof $pp_pic_holder != 'undefined'){
					if($pp_pic_holder.is(':visible')){
						switch(e.keyCode){
							case 37:
								$.prettyPhoto.changePage('previous');
								break;
							case 39:
								$.prettyPhoto.changePage('next');
								break;
							case 27:
								if(!settings.modal)
								$.prettyPhoto.close();
								break;
						};
						return false;
					};
				};
			});
		}
		
		
		/**
		* Initialize prettyPhoto.
		*/
		$.prettyPhoto.initialize = function() {
			settings = pp_settings;
			
			if($.browser.msie && parseInt($.browser.version) == 6) settings.theme = "light_square"; // Fallback to a supported theme for IE6
			
			_buildOverlay(this); // Build the overlay {this} being the caller
			
			if(settings.allow_resize)
				$(window).scroll(function(){ _center_overlay(); });
				
			_center_overlay();
			
			set_position = jQuery.inArray($(this).attr('href'), pp_images); // Define where in the array the clicked item is positionned
			
			$.prettyPhoto.open();
			
			return false;
		}


		/**
		* Opens the prettyPhoto modal box.
		* @param image {String,Array} Full path to the image to be open, can also be an array containing full images paths.
		* @param title {String,Array} The title to be displayed with the picture, can also be an array containing all the titles.
		* @param description {String,Array} The description to be displayed with the picture, can also be an array containing all the descriptions.
		*/
		$.prettyPhoto.open = function(event) {
			if(typeof settings == "undefined"){ // Means it's an API call, need to manually get the settings and set the variables
				settings = pp_settings;
				if($.browser.msie && $.browser.version == 6) settings.theme = "light_square"; // Fallback to a supported theme for IE6
				_buildOverlay(event.target); // Build the overlay {this} being the caller
				pp_images = $.makeArray(arguments[0]);
				pp_titles = (arguments[1]) ? $.makeArray(arguments[1]) : $.makeArray("");
				pp_descriptions = (arguments[2]) ? $.makeArray(arguments[2]) : $.makeArray("");
				isSet = (pp_images.length > 1) ? true : false;
				set_position = 0;
			}

			if($.browser.msie && $.browser.version == 6) $('select').css('visibility','hidden'); // To fix the bug with IE select boxes
			
			if(settings.hideflash) $('object,embed').css('visibility','hidden'); // Hide the flash

			_checkPosition($(pp_images).size()); // Hide the next/previous links if on first or last images.
		
			$('.pp_loaderIcon').show();
		
			// Fade the content in
			if($ppt.is(':hidden')) $ppt.css('opacity',0).show();
			$pp_overlay.show().fadeTo(settings.animation_speed,settings.opacity);

			// Display the current position
			$pp_pic_holder.find('.currentTextHolder').text((set_position+1) + settings.counter_separator_label + $(pp_images).size());

			// Set the description
			$pp_pic_holder.find('.pp_description').show().html(unescape(pp_descriptions[set_position]));

			// Set the title
			(settings.show_title && pp_titles[set_position] != "" && typeof pp_titles[set_position] != "undefined") ? $ppt.html(unescape(pp_titles[set_position])) : $ppt.html('&nbsp;');
			
			// Get the dimensions
			movie_width = ( parseFloat(grab_param('width',pp_images[set_position])) ) ? grab_param('width',pp_images[set_position]) : settings.default_width.toString();
			movie_height = ( parseFloat(grab_param('height',pp_images[set_position])) ) ? grab_param('height',pp_images[set_position]) : settings.default_height.toString();
			
			// If the size is % based, calculate according to window dimensions
			if(movie_width.indexOf('%') != -1 || movie_height.indexOf('%') != -1){
				movie_height = parseFloat(($(window).height() * parseFloat(movie_height) / 100) - 150);
				movie_width = parseFloat(($(window).width() * parseFloat(movie_width) / 100) - 150);
				percentBased = true;
			}else{
				percentBased = false;
			}
			
			// Fade the holder
			$pp_pic_holder.fadeIn(function(){
				imgPreloader = "";
				
				// Inject the proper content
				switch(_getFileType(pp_images[set_position])){
					case 'image':
						imgPreloader = new Image();

						// Preload the neighbour images
						nextImage = new Image();
						if(isSet && set_position > $(pp_images).size()) nextImage.src = pp_images[set_position + 1];
						prevImage = new Image();
						if(isSet && pp_images[set_position - 1]) prevImage.src = pp_images[set_position - 1];

						$pp_pic_holder.find('#pp_full_res')[0].innerHTML = settings.image_markup;
						$pp_pic_holder.find('#fullResImage').attr('src',pp_images[set_position]);

						imgPreloader.onload = function(){
							// Fit item to viewport
							correctSizes = _fitToViewport(imgPreloader.width,imgPreloader.height);

							_showContent();
						};

						imgPreloader.onerror = function(){
							alert('Image cannot be loaded. Make sure the path is correct and image exist.');
							$.prettyPhoto.close();
						};
					
						imgPreloader.src = pp_images[set_position];
					break;
				
					case 'youtube':
						correctSizes = _fitToViewport(movie_width,movie_height); // Fit item to viewport

						movie = 'http://www.youtube.com/v/'+grab_param('v',pp_images[set_position]);
						if(settings.autoplay) movie += "&autoplay=1";
					
						toInject = settings.flash_markup.replace(/{width}/g,correctSizes['width']).replace(/{height}/g,correctSizes['height']).replace(/{wmode}/g,settings.wmode).replace(/{path}/g,movie);
					break;
				
					case 'vimeo':
						correctSizes = _fitToViewport(movie_width,movie_height); // Fit item to viewport
					
						movie_id = pp_images[set_position];
						var regExp = /http:\/\/(www\.)?vimeo.com\/(\d+)/;
						var match = movie_id.match(regExp);
						
						movie = 'http://player.vimeo.com/video/'+ match[2] +'?title=0&amp;byline=0&amp;portrait=0';
						if(settings.autoplay) movie += "&autoplay=1;";
				
						vimeo_width = correctSizes['width'] + '/embed/?moog_width='+ correctSizes['width'];
				
						toInject = settings.iframe_markup.replace(/{width}/g,vimeo_width).replace(/{height}/g,correctSizes['height']).replace(/{path}/g,movie);
					break;
				
					case 'quicktime':
						correctSizes = _fitToViewport(movie_width,movie_height); // Fit item to viewport
						correctSizes['height']+=15; correctSizes['contentHeight']+=15; correctSizes['containerHeight']+=15; // Add space for the control bar
				
						toInject = settings.quicktime_markup.replace(/{width}/g,correctSizes['width']).replace(/{height}/g,correctSizes['height']).replace(/{wmode}/g,settings.wmode).replace(/{path}/g,pp_images[set_position]).replace(/{autoplay}/g,settings.autoplay);
					break;
				
					case 'flash':
						correctSizes = _fitToViewport(movie_width,movie_height); // Fit item to viewport
					
						flash_vars = pp_images[set_position];
						flash_vars = flash_vars.substring(pp_images[set_position].indexOf('flashvars') + 10,pp_images[set_position].length);

						filename = pp_images[set_position];
						filename = filename.substring(0,filename.indexOf('?'));
					
						toInject =  settings.flash_markup.replace(/{width}/g,correctSizes['width']).replace(/{height}/g,correctSizes['height']).replace(/{wmode}/g,settings.wmode).replace(/{path}/g,filename+'?'+flash_vars);
					break;
				
					case 'iframe':
						correctSizes = _fitToViewport(movie_width,movie_height); // Fit item to viewport
				
						frame_url = pp_images[set_position];
						frame_url = frame_url.substr(0,frame_url.indexOf('iframe')-1);
				
						toInject = settings.iframe_markup.replace(/{width}/g,correctSizes['width']).replace(/{height}/g,correctSizes['height']).replace(/{path}/g,frame_url);
					break;
					
					case 'custom':
						correctSizes = _fitToViewport(movie_width,movie_height); // Fit item to viewport
					
						toInject = settings.custom_markup;
					break;
				
					case 'inline':
						// to get the item height clone it, apply default width, wrap it in the prettyPhoto containers , then delete
						myClone = $(pp_images[set_position]).clone().css({'width':settings.default_width}).wrapInner('<div id="pp_full_res"><div class="pp_inline clearfix"></div></div>').appendTo($('body'));
						correctSizes = _fitToViewport($(myClone).width(),$(myClone).height());
						$(myClone).remove();
						toInject = settings.inline_markup.replace(/{content}/g,$(pp_images[set_position]).html());
					break;
				};

				if(!imgPreloader){
					$pp_pic_holder.find('#pp_full_res')[0].innerHTML = toInject;
				
					// Show content
					_showContent();
				};
			});

			return false;
		};

	
		/**
		* Change page in the prettyPhoto modal box
		* @param direction {String} Direction of the paging, previous or next.
		*/
		$.prettyPhoto.changePage = function(direction){
			currentGalleryPage = 0;
			
			if(direction == 'previous') {
				set_position--;
				if (set_position < 0){
					set_position = 0;
					return;
				};
			}else if(direction == 'next'){
				set_position++;
				if(set_position > $(pp_images).size()-1) {
					set_position = 0;
				}
			}else{
				set_position=direction;
			};

			if(!doresize) doresize = true; // Allow the resizing of the images
			$('.pp_contract').removeClass('pp_contract').addClass('pp_expand');

			_hideContent(function(){ $.prettyPhoto.open(); });
		};


		/**
		* Change gallery page in the prettyPhoto modal box
		* @param direction {String} Direction of the paging, previous or next.
		*/
		$.prettyPhoto.changeGalleryPage = function(direction){
			if(direction=='next'){
				currentGalleryPage ++;

				if(currentGalleryPage > totalPage){
					currentGalleryPage = 0;
				};
			}else if(direction=='previous'){
				currentGalleryPage --;

				if(currentGalleryPage < 0){
					currentGalleryPage = totalPage;
				};
			}else{
				currentGalleryPage = direction;
			};
			
			// Slide the pages, if we're on the last page, find out how many items we need to slide. To make sure we don't have an empty space.
			itemsToSlide = (currentGalleryPage == totalPage) ? pp_images.length - ((totalPage) * itemsPerPage) : itemsPerPage;
			
			$pp_pic_holder.find('.pp_gallery li').each(function(i){
				$(this).animate({
					'left': (i * itemWidth) - ((itemsToSlide * itemWidth) * currentGalleryPage)
				});
			});
		};


		/**
		* Start the slideshow...
		*/
		$.prettyPhoto.startSlideshow = function(){
			if(typeof pp_slideshow == 'undefined'){
				$pp_pic_holder.find('.pp_play').unbind('click').removeClass('pp_play').addClass('pp_pause').click(function(){
					$.prettyPhoto.stopSlideshow();
					return false;
				});
				pp_slideshow = setInterval($.prettyPhoto.startSlideshow,settings.slideshow);
			}else{
				$.prettyPhoto.changePage('next');	
			};
		}


		/**
		* Stop the slideshow...
		*/
		$.prettyPhoto.stopSlideshow = function(){
			$pp_pic_holder.find('.pp_pause').unbind('click').removeClass('pp_pause').addClass('pp_play').click(function(){
				$.prettyPhoto.startSlideshow();
				return false;
			});
			clearInterval(pp_slideshow);
			pp_slideshow=undefined;
		}


		/**
		* Closes prettyPhoto.
		*/
		$.prettyPhoto.close = function(){

			clearInterval(pp_slideshow);
			
			$pp_pic_holder.stop().find('object,embed').css('visibility','hidden');
			
			$('div.pp_pic_holder,div.ppt,.pp_fade').fadeOut(settings.animation_speed,function(){ $(this).remove(); });
			
			$pp_overlay.fadeOut(settings.animation_speed, function(){
				if($.browser.msie && $.browser.version == 6) $('select').css('visibility','visible'); // To fix the bug with IE select boxes
				
				if(settings.hideflash) $('object,embed').css('visibility','visible'); // Show the flash
				
				$(this).remove(); // No more need for the prettyPhoto markup
				
				$(window).unbind('scroll');
				
				settings.callback();
				
				doresize = true;
				
				pp_open = false;
				
				delete settings;
			});
		};
	
		/**
		* Set the proper sizes on the containers and animate the content in.
		*/
		_showContent = function(){
			$('.pp_loaderIcon').hide();
			
			$ppt.fadeTo(settings.animation_speed,1);

			// Calculate the opened top position of the pic holder
			projectedTop = scroll_pos['scrollTop'] + ((windowHeight/2) - (correctSizes['containerHeight']/2));
			if(projectedTop < 0) projectedTop = 0;

			// Resize the content holder
			$pp_pic_holder.find('.pp_content').animate({'height':correctSizes['contentHeight']},settings.animation_speed);
			
			// Resize picture the holder
			$pp_pic_holder.animate({
				'top': projectedTop,
				'left': (windowWidth/2) - (correctSizes['containerWidth']/2),
				'width': correctSizes['containerWidth']
			},settings.animation_speed,function(){
				$pp_pic_holder.find('.pp_hoverContainer,#fullResImage').height(correctSizes['height']).width(correctSizes['width']);

				$pp_pic_holder.find('.pp_fade').fadeIn(settings.animation_speed); // Fade the new content

				// Show the nav
				if(isSet && _getFileType(pp_images[set_position])=="image") { $pp_pic_holder.find('.pp_hoverContainer').show(); }else{ $pp_pic_holder.find('.pp_hoverContainer').hide(); }
			
				if(correctSizes['resized']) $('a.pp_expand,a.pp_contract').fadeIn(settings.animation_speed); // Fade the resizing link if the image is resized
				
				if(settings.autoplay_slideshow && !pp_slideshow && !pp_open) $.prettyPhoto.startSlideshow();
				
				settings.changepicturecallback(); // Callback!
				
				pp_open = true;
			});
			
			_insert_gallery();
		};
		
		/**
		* Hide the content...DUH!
		*/
		function _hideContent(callback){
			// Fade out the current picture
			$pp_pic_holder.find('#pp_full_res object,#pp_full_res embed').css('visibility','hidden');
			$pp_pic_holder.find('.pp_fade').fadeOut(settings.animation_speed,function(){
				$('.pp_loaderIcon').show();
				
				callback();
			});
		};
	
		/**
		* Check the item position in the gallery array, hide or show the navigation links
		* @param setCount {integer} The total number of items in the set
		*/
		function _checkPosition(setCount){
			// If at the end, hide the next link
			if(set_position == setCount-1) {
				$pp_pic_holder.find('a.pp_next').css('visibility','hidden');
				$pp_pic_holder.find('a.pp_next').addClass('disabled').unbind('click');
			}else{ 
				$pp_pic_holder.find('a.pp_next').css('visibility','visible');
				$pp_pic_holder.find('a.pp_next.disabled').removeClass('disabled').bind('click',function(){
					$.prettyPhoto.changePage('next');
					return false;
				});
			};
		
			// If at the beginning, hide the previous link
			if(set_position == 0) {
				$pp_pic_holder
					.find('a.pp_previous')
					.css('visibility','hidden')
					.addClass('disabled')
					.unbind('click');
			}else{
				$pp_pic_holder.find('a.pp_previous.disabled')
					.css('visibility','visible')
					.removeClass('disabled')
					.bind('click',function(){
						$.prettyPhoto.changePage('previous');
						return false;
					});
			};
			
			(setCount > 1) ? $('.pp_nav').show() : $('.pp_nav').hide(); // Hide the bottom nav if it's not a set.
		};
	
		/**
		* Resize the item dimensions if it's bigger than the viewport
		* @param width {integer} Width of the item to be opened
		* @param height {integer} Height of the item to be opened
		* @return An array containin the "fitted" dimensions
		*/
		function _fitToViewport(width,height){
			resized = false;

			_getDimensions(width,height);
			
			// Define them in case there's no resize needed
			imageWidth = width, imageHeight = height;

			if( ((pp_containerWidth > windowWidth) || (pp_containerHeight > windowHeight)) && doresize && settings.allow_resize && !percentBased) {
				resized = true, fitting = false;
			
				while (!fitting){
					if((pp_containerWidth > windowWidth)){
						imageWidth = (windowWidth - 200);
						imageHeight = (height/width) * imageWidth;
					}else if((pp_containerHeight > windowHeight)){
						imageHeight = (windowHeight - 200);
						imageWidth = (width/height) * imageHeight;
					}else{
						fitting = true;
					};

					pp_containerHeight = imageHeight, pp_containerWidth = imageWidth;
				};
			
				_getDimensions(imageWidth,imageHeight);
			};

			return {
				width:Math.floor(imageWidth),
				height:Math.floor(imageHeight),
				containerHeight:Math.floor(pp_containerHeight),
				containerWidth:Math.floor(pp_containerWidth) + 40, // 40 behind the side padding
				contentHeight:Math.floor(pp_contentHeight),
				contentWidth:Math.floor(pp_contentWidth),
				resized:resized
			};
		};
		
		/**
		* Get the containers dimensions according to the item size
		* @param width {integer} Width of the item to be opened
		* @param height {integer} Height of the item to be opened
		*/
		function _getDimensions(width,height){
			width = parseFloat(width);
			height = parseFloat(height);
			
			// Get the details height, to do so, I need to clone it since it's invisible
			$pp_details = $pp_pic_holder.find('.pp_details');
			$pp_details.width(width);
			detailsHeight = parseFloat($pp_details.css('marginTop')) + parseFloat($pp_details.css('marginBottom'));
			$pp_details = $pp_details.clone().appendTo($('body')).css({
				'position':'absolute',
				'top':-10000
			});
			detailsHeight += $pp_details.height();
			detailsHeight = (detailsHeight <= 34) ? 36 : detailsHeight; // Min-height for the details
			if($.browser.msie && $.browser.version==7) detailsHeight+=8;
			$pp_details.remove();
			
			// Get the container size, to resize the holder to the right dimensions
			pp_contentHeight = height + detailsHeight;
			pp_contentWidth = width;
			pp_containerHeight = pp_contentHeight + $ppt.height() + $pp_pic_holder.find('.pp_top').height() + $pp_pic_holder.find('.pp_bottom').height();
			pp_containerWidth = width;
		}
	
		function _getFileType(itemSrc){
			if (itemSrc.match(/youtube\.com\/watch/i)) {
				return 'youtube';
			}else if (itemSrc.match(/vimeo\.com/i)) {
				return 'vimeo';
			}else if(itemSrc.indexOf('.mov') != -1){ 
				return 'quicktime';
			}else if(itemSrc.indexOf('.swf') != -1){
				return 'flash';
			}else if(itemSrc.indexOf('iframe') != -1){
				return 'iframe';
			}else if(itemSrc.indexOf('custom') != -1){
				return 'custom';
			}else if(itemSrc.substr(0,1) == '#'){
				return 'inline';
			}else{
				return 'image';
			};
		};
	
		function _center_overlay(){
			if(doresize && typeof $pp_pic_holder != 'undefined') {
				scroll_pos = _get_scroll();
				
				titleHeight = $ppt.height(), contentHeight = $pp_pic_holder.height(), contentwidth = $pp_pic_holder.width();
				
				projectedTop = (windowHeight/2) + scroll_pos['scrollTop'] - (contentHeight/2);
				
				$pp_pic_holder.css({
					'top': projectedTop,
					'left': (windowWidth/2) + scroll_pos['scrollLeft'] - (contentwidth/2)
				});
			};
		};
	
		function _get_scroll(){
			if (self.pageYOffset) {
				return {scrollTop:self.pageYOffset,scrollLeft:self.pageXOffset};
			} else if (document.documentElement && document.documentElement.scrollTop) { // Explorer 6 Strict
				return {scrollTop:document.documentElement.scrollTop,scrollLeft:document.documentElement.scrollLeft};
			} else if (document.body) {// all other Explorers
				return {scrollTop:document.body.scrollTop,scrollLeft:document.body.scrollLeft};
			};
		};
	
		function _resize_overlay() {
			windowHeight = $(window).height(), windowWidth = $(window).width();
			
			if(typeof $pp_overlay != "undefined") $pp_overlay.height($(document).height());
		};
	
		function _insert_gallery(){
			if(isSet && settings.overlay_gallery && _getFileType(pp_images[set_position])=="image") {
				itemWidth = 52+5; // 52 beign the thumb width, 5 being the right margin.
				navWidth = (settings.theme == "facebook") ? 58 : 38; // Define the arrow width depending on the theme
				
				itemsPerPage = Math.floor((correctSizes['containerWidth'] - 100 - navWidth) / itemWidth);
				itemsPerPage = (itemsPerPage < pp_images.length) ? itemsPerPage : pp_images.length;
				totalPage = Math.ceil(pp_images.length / itemsPerPage) - 1;

				// Hide the nav in the case there's no need for links
				if(totalPage == 0){
					navWidth = 0; // No nav means no width!
					$pp_pic_holder.find('.pp_gallery .pp_arrow_next,.pp_gallery .pp_arrow_previous').hide();
				}else{
					$pp_pic_holder.find('.pp_gallery .pp_arrow_next,.pp_gallery .pp_arrow_previous').show();
				};

				galleryWidth = itemsPerPage * itemWidth + navWidth;
				
				// Set the proper width to the gallery items
				$pp_pic_holder.find('.pp_gallery')
					.width(galleryWidth)
					.css('margin-left',-(galleryWidth/2));
					
				$pp_pic_holder
					.find('.pp_gallery ul')
					.width(itemsPerPage * itemWidth)
					.find('li.selected')
					.removeClass('selected');
				
				goToPage = (Math.floor(set_position/itemsPerPage) <= totalPage) ? Math.floor(set_position/itemsPerPage) : totalPage;
				
				
				if(itemsPerPage) {
					$pp_pic_holder.find('.pp_gallery').hide().show().removeClass('disabled');
				}else{
					$pp_pic_holder.find('.pp_gallery').hide().addClass('disabled');
				}
				
				$.prettyPhoto.changeGalleryPage(goToPage);
				
				$pp_pic_holder
					.find('.pp_gallery ul li:eq('+set_position+')')
					.addClass('selected');
			}else{
				$pp_pic_holder.find('.pp_content').unbind('mouseenter mouseleave');
				$pp_pic_holder.find('.pp_gallery').hide();
			}
		}
	
		function _buildOverlay(caller){
			// Find out if the picture is part of a set
			theRel = $(caller).attr('rel');
			galleryRegExp = /\[(?:.*)\]/;
			isSet = (galleryRegExp.exec(theRel)) ? true : false;
			
			// Put the SRCs, TITLEs, ALTs into an array.
			pp_images = (isSet) ? jQuery.map(matchedObjects, function(n, i){ if($(n).attr('rel').indexOf(theRel) != -1) return $(n).attr('href'); }) : $.makeArray($(caller).attr('href'));
			pp_titles = (isSet) ? jQuery.map(matchedObjects, function(n, i){ if($(n).attr('rel').indexOf(theRel) != -1) return ($(n).find('img').attr('alt')) ? $(n).find('img').attr('alt') : ""; }) : $.makeArray($(caller).find('img').attr('alt'));
			pp_descriptions = (isSet) ? jQuery.map(matchedObjects, function(n, i){ if($(n).attr('rel').indexOf(theRel) != -1) return ($(n).attr('title')) ? $(n).attr('title') : ""; }) : $.makeArray($(caller).attr('title'));
			
			$('body').append(settings.markup); // Inject the markup
			
			$pp_pic_holder = $('.pp_pic_holder') , $ppt = $('.ppt'), $pp_overlay = $('div.pp_overlay'); // Set my global selectors
			
			// Inject the inline gallery!
			if(isSet && settings.overlay_gallery) {
				currentGalleryPage = 0;
				toInject = "";
				for (var i=0; i < pp_images.length; i++) {
//					var regex = new RegExp("(.*?)\.(jpg|jpeg|png|gif)$");
					var regex = new RegExp(".*\.(jpg|jpeg|png|gif)\??.*");
					var results = regex.exec( pp_images[i] );
					if(!results){
						classname = 'default';
					}else{
						classname = '';
					}
					toInject += "<li class='"+classname+"'><a href='#'><img src='" + pp_images[i] + "' width='50' alt='' /></a></li>";
				};
				
				toInject = settings.gallery_markup.replace(/{gallery}/g,toInject);
				
				$pp_pic_holder.find('#pp_full_res').after(toInject);
				
				$pp_pic_holder.find('.pp_gallery .pp_arrow_next').click(function(){
					$.prettyPhoto.changeGalleryPage('next');
					$.prettyPhoto.stopSlideshow();
					return false;
				});
				
				$pp_pic_holder.find('.pp_gallery .pp_arrow_previous').click(function(){
					$.prettyPhoto.changeGalleryPage('previous');
					$.prettyPhoto.stopSlideshow();
					return false;
				});
				
				$pp_pic_holder.find('.pp_content').hover(
					function(){
						$pp_pic_holder.find('.pp_gallery:not(.disabled)').fadeIn();
					},
					function(){
						$pp_pic_holder.find('.pp_gallery:not(.disabled)').fadeOut();
					});

				itemWidth = 52+5; // 52 beign the thumb width, 5 being the right margin.
				$pp_pic_holder.find('.pp_gallery ul li').each(function(i){
					$(this).css({
						'position':'absolute',
						'left': i * itemWidth
					});

					$(this).find('a').unbind('click').click(function(){
						$.prettyPhoto.changePage(i);
						$.prettyPhoto.stopSlideshow();
						return false;
					});
				});
			};
			
			
			// Inject the play/pause if it's a slideshow
			if(settings.slideshow){
				$pp_pic_holder.find('.pp_nav').prepend('<a href="#" class="pp_play">Play</a>')
				$pp_pic_holder.find('.pp_nav .pp_play').click(function(){
					$.prettyPhoto.startSlideshow();
					return false;
				});
			}
			
			$pp_pic_holder.attr('class','pp_pic_holder ' + settings.theme); // Set the proper theme
			
			$pp_overlay
				.css({
					'opacity':0,
					'height':$(document).height(),
					'width':$(document).width()
					})
				.bind('click',function(){
					if(!settings.modal) $.prettyPhoto.close();
				});

			$('a.pp_close').bind('click',function(){ $.prettyPhoto.close(); return false; });

			$('a.pp_expand').bind('click',function(e){
				// Expand the image
				if($(this).hasClass('pp_expand')){
					$(this).removeClass('pp_expand').addClass('pp_contract');
					doresize = false;
				}else{
					$(this).removeClass('pp_contract').addClass('pp_expand');
					doresize = true;
				};
			
				_hideContent(function(){ $.prettyPhoto.open(); });
		
				return false;
			});
		
			$pp_pic_holder.find('.pp_previous, .pp_nav .pp_arrow_previous').bind('click',function(){
				$.prettyPhoto.changePage('previous');
				$.prettyPhoto.stopSlideshow();
				return false;
			});
		
			$pp_pic_holder.find('.pp_next, .pp_nav .pp_arrow_next').bind('click',function(){
				$.prettyPhoto.changePage('next');
				$.prettyPhoto.stopSlideshow();
				return false;
			});
			
			_center_overlay(); // Center it
		};
		
		return this.unbind('click').click($.prettyPhoto.initialize); // Return the jQuery object for chaining. The unbind method is used to avoid click conflict when the plugin is called more than once
	};
	
	function grab_param(name,url){
	  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
	  var regexS = "[\\?&]"+name+"=([^&#]*)";
	  var regex = new RegExp( regexS );
	  var results = regex.exec( url );
	  return ( results == null ) ? "" : results[1];
	}
	
})(jQuery);
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Commented out because I cannot submit pictures with that serialize()
/**
* Submit forms through AJAX

$(document).ready(function(){
   $('#new_event').submit(function(){
      $.post($(this).attr('action'), $(this).serialize(), null, "script");
      return false;
   });
});

$('.notice').fadeOut(2000,function(){$(this).remove();});
*/


/**
* Controls the action menu on the Home Page portlets
*/

$(document).ready(function(){
   // observe ANY clicks on the whole doc (webpage)
   $(document).click(function(event){
      // what element did the event happen on
      var $element = $(event.target);
      // if it happenend on the action-span
      if ($element.hasClass('action-span')) {
         // if it happened on an already open menu
         if ($element.parent().hasClass('menu-open')) {
            // then toggle it (close it basically)
            $element.parent().next().toggle();
            $element.parent().toggleClass('menu-open');
         } else {
            // close all menus that are already open
            $("div.list-action-menu").each(function (i) {
               if ($(this).prev().hasClass('menu-open')) {
                  $(this).hide();
                  $(this).prev().toggleClass('menu-open');
               }
   	      });
            //and open this one
            $element.parent().next().toggle();
            $element.parent().toggleClass('menu-open');
         }
      } else { // user didn't click on any menu so close all open ones
         $("div.list-action-menu").each(function (i) {
            if ($(this).prev().hasClass('menu-open')) {
               $(this).hide();
               $(this).prev().toggleClass('menu-open');
            }
	      });
	   }
   });
});

// Need this to get round an issue with rails_ujs which prevents form submission
// when required fields are present but does not show an error message indicating
// why it is not submitting.  When we implement Modernizr we should remove this.
$('form').live('ajax:aborted:required', function(event, elements){
  // If user answers 'OK' to confirm dialog, we return false
  return false;
});

// Begin More/Less
$(document).ready(function() {
//alert($('.description').height());
  if ($('.description').height() > 90) {
      $('<span class="show_more">more ...</span>').insertAfter('.description');
      $('<span class="show_less">less</span>').insertAfter('.description').hide();
      $('.description').height('75px');
      $('.show_more').click(function() {
        $(this).hide();
        $('.description').height('auto');
        $('.show_less').show();
      });
      $('.show_less').click(function() {
        $(this).hide();
        $('.description').height('75px');
        $('.show_more').show();
      });
    }
});

// End Begin More/Less


$(".jqueryui_date").live('focus', function() {
   $(this).datepicker({
    altField: $(this).next(),
    altFormat: "yy-mm-d"
   });
});




/**
* Hijack the Show Winery Detrails link
*/
$(document).ready(function(){
    $('.show_details').click(function(e) {
        alert("Clicked Details")
    });
});

/**
* control User Sign in drop down menu
*/
$(document).ready(function() {

   $(".signin").click(function(e) {
       $(this).next("div#signin_menu").toggle('fast');
/*       $(this).toggleClass("menu-open"); */
       e.preventDefault();
   });
/*
   $("div#signin_menu").mouseup(function() {
       return false
   });

   $(document).mouseup(function(e) {
       if($(this).parent("a.signin").length==0) {
           $(".signin").removeClass("menu-open");
           $("div#signin_menu").hide('slow');
       }
   });
*/
/*   addNotice("<p>Welcome to Barrelrun!</p>");
   setTimeout(function() { addNotice("<p>Stay awhile!</p><p>Stay FOREVER!</p>"); }, 2000); */

 });

/**
* function that adds notices to growl like message box in bottom right corner
*/
function addNotice(notice) {
   $('<div class="notices"></div>')
      .append('<div class="skin"></div>')
      .append('<a href="#" class="close">close</a>')
      .append($('<div class="content"></div>').html($(notice)))
      .hide()
      .appendTo('#message_box')
      .fadeIn(1000)
/* This works but seems to disable the close functionality */
      .delay(10000).fadeOut(1000, function(){$(this).remove();});
/*   setTimeout(function() { $('.notice').fadeOut(); }, 10000); */
}

$('#message_box')
   .find('.close')
   .live('click', function() {
      $(this)
         .closest('.notice')
         .clearQueue()
         .stop()
         .animate({
            border: 'none',
            height: 0,
            marginBottom: 0,
            marginTop: '-6px',
            opacity: 0,
            paddingBottom: 0,
            paddingTop: 0,
            queue: false
         }, 1000, function() {
            $(this).remove();
         });
});


$.fn.center = function () {
    this.css("position","absolute");
    this.css("top", ( $(window).height() - this.height() ) / 2+$(window).scrollTop() + "px");
    this.css("left", ( $(window).width() - this.width() ) / 2+$(window).scrollLeft() + "px");
    return this;
}

//$(document).ready(function(){
//  $('.gallery_images').galleria();
//});


$(document).ready(function(){
  $("a[rel^='prettyPhoto']").prettyPhoto({
    theme: 'facebook',
    hideflash: true,
    flash_markup: '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="{width}" height="{height}"><param name="wmode" value="{wmode}" /><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="movie" value="{path}?rel=0&amp;showsearch=0&amp;showinfo=0" /><embed src="{path}?rel=0&amp;showsearch=0&amp;showinfo=0" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="{width}" height="{height}" wmode="{wmode}"></embed></object>'
  });
});

/**
* opening modal Dialog for form (with dynamic content added on the fly)
*/
$('.dialog_form_link').live('click', function() {
    var link = "http://www.barrelrun.com" + $(this).attr('href');
    var $dialog = $('<div class="dialog"></div>')
        .appendTo('body')
        .load($(this).attr('href') + ' .entry_form', function(response, status, xhr){
            if (status == "error") {
                var msg = "Sorry but there was an error: ";
                addNotice("<p>" + msg + xhr.status + " " + xhr.statusText + "</p>")
            } else {
                starRating.create('.dialog .stars');
                $(".addthis_toolbox")
                    .append('<a class="addthis_button_email" style="float: left;"></a>')
                    .append('<a class="addthis_button_facebook" style="float: left;"></a>')
                    .append('<a class="addthis_button_twitter" style="float: left;"></a>')
                addthis.toolbox(".addthis_toolbox",{},{url: link, title: "Barrelrun"});
//<div class="addthis_toolbox" addthis:url="http://example.com/blog/post/2009/05/01" addthis:title="Hooray!">
//    <a class="addthis_button_compact">Share</a>
//    <a class="addthis_button_email"></a>
//    <a class="addthis_button_facebook"></a>
//    <a class="addthis_button_buzz"></a>
//</div>



                addthis.button("#dialog_atbutton", {ui_click: true, services_compact: 'facebook, twitter'}, {url: link, title: "Barrelrun"});
//                addthis.toolbox(".addthis_toolbox", {ui_click: true, services_expanded: "facebook, twitter"}, {url: link, title: "Barrelrun"});

//                $('.gallery_images').galleria();
                $("a[rel^='prettyPhoto']").prettyPhoto({theme: 'facebook', hideflash: true});

                $('#wine_varietal').autocomplete({
                  source: "/wines/distinct_varietals.json",
                  minLength: 1
                });
                $('#wine_wine_type').autocomplete({
                  source: "/wines/distinct_wine_types.json",
                  minLength: 1
                });
                $('div.comments').hide();
                $(this).dialog({
                    modal: true,
                    title: $('.name').text(),
    //                autoOpen: false,
                    width: 'auto',
                    height: 'auto',
                    position: 'center',
                    show: {effect: 'blind',
                           duration: 250
                    },
                    hide: {effect: 'blind', duration: 250},
                    close: function(ev, ui) { $('div.dialog').remove(); }
                });
            }
        });
//    $dialog.dialog('open');
    // prevent the default action, e.g., following a link
    return false;
});


/**
* opening content of link in modal Dialog)
*/
$('.dialog_link').live('click', function() {
    var $dialog = $('<div class="dialog"></div>')
        .load($(this).attr('href'), function(response, status, xhr){
            if (status == "error") {
                var msg = "Sorry but there was an error: ";
                addNotice("<p>" + msg + xhr.status + " " + xhr.statusText + "</p>")
            } else {
                $(this).dialog({
                    modal: true,
                    title: $('.name').text(),
    //                autoOpen: false,
                    width: 'auto',
                    height: 'auto',
                    position: 'center',
                    show: {effect: 'blind',
                           duration: 250
                    },
                    hide: {effect: 'blind', duration: 250},
                    close: function(ev, ui) { $('div.dialog').remove(); }
                });
            }
        });
    return false;
});



/**
* Makes the scrollable area actually scrollable using jquery ui tools
*/
//$(".scrollable").live('mouseover', function(e) {
//	$(this).scrollable();
//});

/**
* Remove Picture Fuctionality
*/
$('#remove_picture').live('click', function() {
    // Set delete_flag on hidden _destroy field
    $(this).prev("input[type=hidden]").val("1");
    //remove the whole picture field
    $(this).closest(".picture_field").slideUp();
    // prevent the default action, e.g., following a link
    return false;
});

/**
* Add Picture Field Fuctionality
*/
//$(document).ready(function(){
  $('form a.add_child').live('click', function() {
//  $('form a.add_child').click, function() {
    var association = $(this).attr('data-association');
    var template = $('#' + association + '_fields_template').html();
    var regexp = new RegExp('new_' + association, 'g');
    var new_id = new Date().getTime();

    $("#picture_fields").append(template.replace(regexp, new_id));
    $("#picture_fields").children(':last').hide().slideDown();

    return false;
  });
//};

/*  $('form a.remove_child').live('click', function() {
    var hidden_field = $(this).prev('input[type=hidden]')[0];
    if(hidden_field) {
      hidden_field.value = '1';
    }
    $(this).parents('.fields').hide();
    return false;
  }); */
//});


/**
* Delete Row from table (and DB) Fuctionality
*/
$(document).ready(function(){
  $('a.delete').live('click', function(){
    if(confirm("Are you sure?")){
      var row = $(this).closest("tr").get(0);
      $.post(
        this.href,
        {_method:'delete'},
        function(data, status){
          if (status == 'success'){
            $(row).fadeOut(
              'fast',
              function(){
                addNotice("<p>Delete was successful.</p>");
              }
            );
          }
          else {
            addNotice("<p>" + data.base[0] + "</p>");
          }
        }
      );
      return false;
    } else {
      //they clicked no.
      return false;
    }
  });
});

/**
* Delete Row from table (and DB) Fuctionality
* V2 : BETTER AND IMPROVED :-)
*/
$(document).ready(function(){
    $('a.delete_it').click (function(){
        if(confirm("Are you sure?")){
            var row = $(this).closest("tr").get(0);
            $.post(this.href, {_method:'delete'}, function(){addNotice("<p>Wine was successfully deleted.</p>");}, "script");

            $(row).slideUp();

            return false;
        } else {
            //they clicked no.
            return false;
        }
    });
});


/**
* AJAX Pagination
*/
//$(document).ready(function(){
//  $(".pagination a").live("click", function() {
////    $(".pagination").html("Page is loading...");
//    $.getScript(this.href);
//    return false;
//  });
//});

$(document).ajaxError(function(event, request) {
  var msg = request.getResponseHeader('X-Message');
  if (msg) addNotice('<p>' + msg + '</p>');
});

$(document).ajaxSuccess(function(event, request) {
  var msg = request.getResponseHeader('X-Message');
  if (msg) addNotice('<p>' + msg + '</p>');
});

/**
* AJAX Pagination on Lists
*/
$(document).ready(function(){
  $(".pagination a").live("click", function() {
    $list = $(this).closest('div.list').parent();
    $.get($(this).attr('href'), function(data){
      $list.html(data);
      starRating.create('.stars', $list);
    });
    return false;
  });
});


/**
* Custom Build Star Rating System from scratch
*/
$(document).ready(function(){
  starRating.create('.stars');
  $('div.comments').hide();
});

// The widget
var starRating = {
  create: function(selector, dom_element) {
    // loop over every element matching the selector
    if (!dom_element) {
      dom_element = $(document);
    };
    $(dom_element).find(selector).each(function() {
      var $list = $('<div></div>');
      // loop over every radio button in each containerst
      $(this)
        .find('input:radio')
        .each(function(i) {
          var rating = $(this).attr('value');
          if ($(this).is(':disabled')) {
              var $item = $('<a href="#" style="cursor:default;"></a>')
                .addClass(i % 2 == 1 ? 'rating-right' : '');
          } else {
              var $item = $('<a href="' + $(this).parent().attr('action') + '"></a>')
                .attr('title', rating)
                .addClass(i % 2 == 1 ? 'rating-right' : '')
                .text(rating);

              starRating.addHandlers($item);
          }

          $list.append($item);

          if($(this).is(':checked')) {
            $item.prevAll().andSelf().addClass('rating');
          }
        });
        // Hide the original radio buttons
        $(this).append($list).find('input:radio').hide();
    });
  },
  addHandlers: function(item) {
    $(item).click(function(e) {
      // Handle Star click
      var $star = $(this);
      var $allLinks = $(this).parent();
//    alert('clicked stars');
      // Set the radio button value
      $allLinks
        .parent()
        .find('input:radio[value=' + $star.text() + ']')
        .attr('checked', true);

      // Set the ratings
      $allLinks.children().removeClass('rating');
      $star.prevAll().andSelf().addClass('rating');

      // prevent default link click
      e.preventDefault();

      $list = $(this).closest('div.list').parent();

      $.post($(this).attr('href'), {stars: $star.text() }, function(data){
// THIS WILL WORK FOR RATING FAVORITES, NEED TO GET IT WORKING FOR RATING WINES ETC.
          $list.html(data);
          starRating.create('.stars', $list);
// THIS WILL WORK FOR RATING FAVORITES, NEED TO GET IT WORKING FOR RATING WINES ETC.
//        $('#top_wines').load('home/top_wines', function(){
//        $(this).closest('#top_list').parent().load('home/top_wines', function(){
//            starRating.create('#top_wines .stars');
//          });
        },
        "html");
//        "script");
    }).hover(function() {
      // Handle star mouse over
      $(this).prevAll().andSelf().addClass('rating-over');
    }, function() {
      // Handle star mouse out
      $(this).siblings().andSelf().removeClass('rating-over')
    });
  }
}


/**
* Submit comments
*/
$('a.write_comment').live('click', function() {
//  $('div.comments').slideToggle();
  $(this).closest('div.comment_block').find('div.comments').slideToggle();
  $('#comment_content').val("");
  return false;
});

$('#new_comment').live('submit', function(){
  $.post($(this).attr('action'), $(this).serialize(), null, "script");
//  $('div.comments').slideToggle();
  $(this).closest('div.comment_block').find('div.comments').slideToggle();
  $('#comment_content').val("");
  return false;
});


/**
* Hijack "Add as Favorite" link
*/
$('.add_as_favorite').live('click', function() {
    $this = $(this);
    $.post(
      $this.attr('href'),
      function(data) {
        $this.text('Remove from favorites');
        $this.attr(
          {class: 'remove_as_favorite',
           title: 'Remove From My Favorites',
           href: "/" + data[0] + "/" + data[1] + "/favorites/" + data[2]
        });
      },
      "json"
    );
    return false;
});

/**
* Hijack click on Remove as Favorite link
*/
$('.remove_as_favorite').live('click', function() {
    $this = $(this);
    $.ajax({
      url: $this.attr('href'),
      type: "delete",
      success: function(data) {
        $this.text('Add to My Favorites');
        $this.attr(
          {class: 'add_as_favorite',
           title: 'Add to My Favorites',
           href: "/" + data[0] + "/" + data[1] + "/favorites"
        });
      },
      dataType: "json"
    });
    return false;
});


/**
* Hijack the Refresh link
*/
$(document).ready(function(){
    $('.refresh').click(function(e) {
        alert("Clicked Refresh")
        return false;
    });
});


/**
* Load Favorites Dynamically
*/
$(document).ready(function(){
    $('#fav_wine_list').load('favorites/favorite_wines', function(){
        starRating.create('#fav_wine_list .stars');
    });
    $('#fav_winery_list').load('favorites/favorite_wineries', function(){
        starRating.create('#fav_winery_list .stars');
    });
    $('#fav_special_list').load('favorites/favorite_specials', function(){
        starRating.create('#fav_special_list .stars');
    });
    $('#fav_event_list').load('favorites/favorite_events', function(){
        starRating.create('#fav_event_list .stars');
    });
});


/**
* Scroll Bar of jquerytools
*/
$(document).ready(function(){
    scrollable ('.pic_scroll');
    scrollable ('.vid_scroll');
});

function scrollable (selector) {
    // get handle to the scrollable DIV
    var scroll = $(selector);

    // initialize rangeinput
    $(selector + ':range').rangeinput({
	    // slide the DIV along with the range using jQuery's css() method
	    onSlide: function(ev, step)  {
		    scroll.css({left: -step});
	    },

	    // display progressbar
	    progress: true,

	    // initial value. also sets the DIV's initial scroll position
	    value: 0,

	    // this is called when the slider is clicked. we animate the DIV
	    change: function(e, i) {
		    scroll.animate({left: -i}, "fast");
	    },

	    // disable drag handle animation when slider is clicked
	    speed: 0
    });

    $(selector + ':range').bind('onSlide', function(){}); // fixes a bug in jquery 1.4.4
}

/**
* Accordion on search page
*/
$(document).ready(function(){
  // Hide all facets
  $('.accordion h4').next().hide();
  // Now show the ones that have a checked box
  $('input:checked').each(function() {
    $(this)
      .parent().show()
      .closest('.facet').addClass('open');
  });
  //toggle accordion when clicked
  $('.accordion h4').click(function() {
    $(this).parent().toggleClass('open');
    $(this).next().slideToggle('fast');
    return false;
  });
  // show distance value
  $('#distance').change(function() {
	$('#miles').html($(this).val());
  });
});

/**
* JQUery Plugin Star Rating System

$(document).ready(function(){
    $(".star_ratings").stars();
});
*/

;
$(document).ready(function(){
  var defaultLatLng = new google.maps.LatLng( 51.226401, 5.302663); //change this to something more appropriate

  var myOptions = {
    zoom: 8,
    scrollwheel: false,
    mapTypeId: google.maps.MapTypeId.TERRAIN,
    mapTypeControlOptions: {
      style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
    },
  };

  var map = new google.maps.Map($('#map').get(0), myOptions);
  var markersArray = [];

  /**
  * Place wineries on map
  * TODO: Pass in users location so I can get the wineries around his location
  */
  var infoWindow = new google.maps.InfoWindow({});

  $.getJSON("/wineries/",
      function(wineries) {
          for (var i=0; i<wineries.length; i++){
              var winery = wineries[i];
              var latLng = new google.maps.LatLng(winery.winery.lat, winery.winery.lng);
              var marker = new google.maps.Marker({
                  position: latLng,
                  map: map,
                  title: winery.winery.winery_name,
                  html: infoWindowContent(winery.winery),
                  icon: '/assets/barrelrun/map_icon.png'
              });
  //            marker.set('Winery', winery);
              google.maps.event.addListener(marker,
                  "click",
                  function(event) {
                       infoWindow.setContent(this.html);
                       infoWindow.open(map,this);
                       map.panTo(this.position);
                  }
              );
              markersArray.push(marker);
          };
      }
  );

  if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(successCallback, errorCallback,  {maximumAge:60000, timeout: 2000});
  } else {
      addNotice("<p>Your browser does not support geolocation so we defaulted your location as best we could.<p>");
      setDefaultLocation();
  };

  function successCallback (position) {
      var latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
      map.setCenter(latlng);
  };

  function errorCallback(error) {
      switch(error.code) {
          case error.UNKNOWN_ERROR:
              addNotice("<p>Due to an unknown error we could not locate you so we defaulted your location as best we could.<p>");
              setDefaultLocation();
              break;
          case error.PERMISSION_DENIED:
              addNotice("<p>You denied us permission to use geolocation so we defaulted your location as best we could.<p>");
              setDefaultLocation();
              break;
          case error.POSITION_UNAVAILABLE:
              addNotice("<p>Your postion is currently unavailable to use so we defaulted your location as best we could.<p>");
              setDefaultLocation();
              break;
          case error.TIMEOUT:
              addNotice("<p>Geolocation call timed out so we defaulted your location as best we could.<p>");
              setDefaultLocation();
              break;
          default:
              addNotice("<p>We had some trouble determining your location so we defaulted your location as best we could.<p>");
              setDefaultLocation();
      };
  }

  function infoWindowContent(winery) {
      var contentString =
          '<div class="infoWindowContent span-6" >' +
              '<h3>' + winery.winery_name + '</h3>' +
              '<div class="span-5 prepend-1 last" >' +
                  winery.address + '<br>' +
                  winery.city + ', ' + winery.state + ' ' + winery.zipcode + '<br>' +
                  winery.country + '<br>' +
              '</div>' +
              '<div class="span-5 prepend-1 last" >' +
                  '<a href="/wineries/' + winery.id + '">View winery details ... </a>' +
              '</div>' +
          '</div>';

      return contentString;
  }

  function setDefaultLocation () {
      $.getJSON("/home/default_location",
          function (defaultPosition){
              defaultLatLng = new google.maps.LatLng(defaultPosition.lat, defaultPosition.lng);
              map.setCenter(defaultLatLng);
          }
      );
  }

  /**
  * Map It functionality
  */
  $('.map-wine').live('click', function() {
    var latLng = new google.maps.LatLng($(this).attr("data-winery-lat"), $(this).attr("data-winery-lng"));
    map.panTo(latLng);
    if (markersArray) {
      for (i in markersArray) {
        if (markersArray[i].position.equals(latLng)) {
          infoWindow.setContent(markersArray[i].html);
          infoWindow.open(map,markersArray[i]);
          break;
        };
      };
    };
  });

});

// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//

;
