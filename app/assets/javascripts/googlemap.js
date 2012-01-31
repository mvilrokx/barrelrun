$(document).ready(function(){
  var defaultLatLng = new google.maps.LatLng( 51.226401, 5.302663); //change this to something more appropriate

  var myOptions = {
    zoom: 8,
    scrollwheel: false,
    mapTypeId: google.maps.MapTypeId.TERRAIN,
    mapTypeControlOptions: {
      style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
    }
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
  };

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
  };

  function setDefaultLocation () {
      $.getJSON("/home/default_location",
          function (defaultPosition){
              defaultLatLng = new google.maps.LatLng(defaultPosition.lat, defaultPosition.lng);
              map.setCenter(defaultLatLng);
          }
      );
  };

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

