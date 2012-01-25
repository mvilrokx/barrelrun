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
