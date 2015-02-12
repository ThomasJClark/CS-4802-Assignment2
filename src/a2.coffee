# a2.coffee: main rendering functions for assignment 2.
#
# Thomas Clark - CS 4802 Assignment 2

svg = (d3.select 'body').append 'svg:svg'
  .attr
    width: 1280
    height: 720
    preserveAspectRatio: 'none'
  .style
    display: 'block'
    margin: 'auto'

# showKey()
#
# Render a key at the top of the screen that describes the meaning behind each
# visual element.
showKey = () ->
  textAttr =
    'text-anchor': 'middle'
    'dominant-baseline': 'hanging'
    'font-size': '1em'
    'font-family': '"Helvetica Neue",Helvetica,Arial,sans-serif'
    'font-weight': 'bold'

  # Make a gradient to show the range of colors
  gradient = (svg.append 'svg:defs').append 'svg:linearGradient'
    .attr 'id', 'gradient'
  gradient.append 'svg:stop'
    .attr
      offset: '0%'
      'stop-color': renderTree._colorSpace 1
  gradient.append 'svg:stop'
    .attr
      offset: '100%'
      'stop-color': renderTree._colorSpace 0

  svg.append 'svg:rect'
    .attr
      x1: 0
      y1: 0
      width: 200
      height: 10
      transform: "translate(#{ (svg.attr 'width') / 2 - 100 }, 0)"
    .style
      fill: 'url(#gradient)'
  svg.append 'text'
    .text 'More Mismatches'
    .style textAttr
    .attr
      x: (svg.attr 'width') / 2 - 100
      y: 11
  svg.append 'text'
    .text 'Fewer Mismatches'
    .attr textAttr
    .attr
      x: (svg.attr 'width') / 2 + 100
      y: 11

  svg.append 'svg:polygon'
    .attr
      points: '0,5 200,0 200,11 0,6'
      transform: "translate(#{ (svg.attr 'width') / 2 - 100 }, 40)"
    .style
      fill: renderTree._lineColor
  svg.append 'text'
    .text 'Weak Cluster'
    .attr textAttr
    .attr
      x: (svg.attr 'width') / 2 - 100
      y: 51
  svg.append 'text'
    .text 'Strong Cluster'
    .attr textAttr
    .attr
      x: (svg.attr 'width') / 2 + 100
      y: 51


# Load the CSV data and render it
d3.csv 'zoo.csv',
  (error, animals) ->
    showKey()
    renderTree.render cluster.bottomUpCluster animals
