# all.coffee
path = d3.geo.path()
fill = d3.scale.log().clamp(true).range ['#fff', '#0aafed']

width = $('.js-map').outerWidth()
height = 500

vis = d3.select('.js-map').append('svg')
  .attr('width', width)
  .attr('height', height)

percentOfPopulation = (props) ->
  props.count = 0 if not props.count?
  (props.count / (props.m1519 + props.m2024)) * 100

d3.json 'data/counties.json', (data) ->
  counties = topojson.feature data, data.objects.counties
  max = d3.max counties.features, (d) -> percentOfPopulation(d.properties)
  fill.domain [0.1, max]

  vis.selectAll('.county')
    .data(counties.features)
  .enter().append('path')
    .attr('class', 'county')
    .style('fill', (d) -> fill(percentOfPopulation(d.properties)))
    .attr('d', path)
    .on 'click', (d) -> console.log d
