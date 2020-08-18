function Map(map, center){
  function loadMarkerPos(callback) {
    fetch('/markers?center=' + center.join(','), { cache: 'no-cache' })
      .then(response => response.json())
      .then(data => callback(data));
  }

  var tiles = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
    maxZoom: 18,
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  });

  var markers = [];
  var last_markers_of_ids = [];
  map.addLayer(tiles);

  setInterval(function(){
    loadMarkerPos(data => {
      var count = Object.keys(data).length
      document.getElementById("marker_count").textContent = "count of markers: " + count;
      Object.keys(data).forEach(id => {
        var pos = data[id];
        console.log("----------")
        console.log(id);
        console.log(pos);
        var x = pos["latitude"];
        var y = pos["longitude"];
        if (markers[id] == undefined) {
          markers[id] = L.Marker.movingMarker([[x, y]], [], {});
          markers[id].bindPopup(id).addTo(map);
          console.log("new marker:" + id);
        } else {
          markers[id].moveTo([x, y], 500);
        }
        if (last_markers_of_ids[id] != undefined) {
          delete last_markers_of_ids[id]
        }
      });

      Object.keys(last_markers_of_ids).forEach(id => {
        map.removeLayer(markers[id]);
        delete markers[id];
        console.log("marker was out:" + id);
      });

      last_markers_of_ids = []
      Object.keys(markers).forEach(id => {
        last_markers_of_ids[id] = true;
      });
    });
  }, 1000);
};

