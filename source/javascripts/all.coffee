# all.coffee
path = d3.geo.path()
fill = d3.scale.log().clamp(true).range ['#fff', '#0aafed']

width = $('.js-map').outerWidth()
height = 500

vis = d3.select('.js-map').append('svg')
  .attr('width', width)
  .attr('height', height)

d3.json 'data/counties.json', (data) ->
  counties = topojson.feature data, data.objects.counties
  counties.features.forEach (d) ->
    props = d.properties
    props.count = 0 if not props.count?
    props.mpop = (props.count / (props.m1519 + props.m2024)) * 100

  max = d3.max counties.features, (d) -> d.properties.mpop
  fill.domain [0.01, max]

  vis.selectAll('.county')
    .data(counties.features)
  .enter().append('path')
    .attr('class', 'county')
    .style('fill', (d) -> if d.properties.mpop == max then 'red' else fill(d.properties.mpop))
    .attr('d', path)
    .on 'click', (d) ->
      console.log "#{d.properties.mpop.toFixed(2)}% of males play college football in #{d.properties.name}"
