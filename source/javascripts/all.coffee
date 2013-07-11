# all.coffee
path = d3.geo.path()
fill = d3.scale.log().clamp(true).range(['#fff', '#0aafed']) #.nice()
#fill = d3.scale.linear().clamp(true).range(['#fff', '#0aafed']) #.nice()

width = $('.js-map').outerWidth()
height = 500

tip = d3.tip().attr('class', 'd3-tip').html (d) ->
  p = d.properties
  " <h3>#{p.name}</h3>
    <p><span>#{p.mpop.toFixed(2)}%</span> (#{p.count}) of <span>#{d3.format(',')(p.m1519 + p.m2024)}</span> college-age males
    play football.<sup>*</sup></p>
  "

vis = d3.select('.js-map').append('svg')
  .attr('width', width)
  .attr('height', height)
  .call(tip)

d3.json 'data/college-football.json', (data) ->
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
    .style('fill', (d) -> if d.properties.mpop >= 1 then '#c00' else fill(d.properties.mpop))
    .attr('d', path)
    .on('click', tip.show)

    # .on 'click', (d) ->
    #   console.log "#{d.properties.mpop.toFixed(2)}% (#{d.properties.count} of #{d.properties.m1519 + d.properties.m2024}) of males play college football in #{d.properties.name}"

  vis.append('path')
    .datum(topojson.mesh(data, data.objects.states))
    .attr('class', 'state')
    .attr('d', path)

  vis.append('path')
    .datum(topojson.mesh(data, data.objects.land))
    .attr('class', 'land')
    .attr('d', path)
