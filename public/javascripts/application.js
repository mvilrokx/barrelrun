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


$(".jqueryui_date").live('focus', function() {
   $(this).datepicker({
    altField: $(this).next(),
    altFormat: "yy-mm-d"
   });
});


/**
* Map It functionality
*/
 /* $(document).ready(function(){
    $('.map-wine').click(function(e) { */
$('.map-wine').live('click', function() {
/*    $('.map-wine').hover(function(e) { */
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

   /* }); */
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
                    if (data.length > 0){
                        addNotice("<p>" + data[0][1] + "</p>");
                    }
                    else {
                        $(row).fadeOut(
                            'fast',
                            function(){
                                addNotice("<p>Delete was successful.</p>");
                            });
                    }
                });
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
    $.post($(this).attr('href'), null, null, "script");
    return false;
});

/**
* Hijack click on Remove as Favorite link
*/
$('.remove_as_favorite').live('click', function() {
    $.ajax({ url: $(this).attr('href'),
             type: "delete",
             dataType: "script"
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

