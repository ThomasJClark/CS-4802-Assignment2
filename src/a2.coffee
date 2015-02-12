# a2.coffee: main rendering functions for assignment 2.
#
# Thomas Clark - CS 4802 Assignment 2

treeData = undefined
colorSpace = d3.interpolateRgb '#FF3341', '#FBD2D4'
lineColor = '#CCB8BA'

svg = (d3.select 'body').append 'svg:svg'
  .attr
    width: 1280
    height: 720
    preserveAspectRatio: 'none'
  .style
    display: 'block'
    margin: 'auto'

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
    'stop-color': colorSpace 1
gradient.append 'svg:stop'
  .attr
    offset: '100%'
    'stop-color': colorSpace 0

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
  .attr textAttr
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
    fill: lineColor
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

tree = d3.layout.tree()
  .size [360, 700]
  .value (d) -> d.animalname
  .children (d) -> d.children
  .separation (a, b) -> 2 / a.depth

treeGroup = svg.append 'g'
  .attr 'transform', 'translate(640, 70)'

diagonal = d3.svg.diagonal.radial()
  .projection (d) -> [d.y, (d.x + 180) / 180 * Math.PI / 2]

render = () ->
  nodeData = tree.nodes treeData
  linkData = tree.links nodeData

  colorRange = d3.scale.linear()
    .domain [cluster.lowestDistance, cluster.highestDistance]
    .range [0, 1]

  strokeRange = d3.scale.linear()
    .domain [cluster.lowestDistance, cluster.highestDistance]
    .range [10, 1]

  # Render links as paths
  link = treeGroup.selectAll 'g.link'
    .data linkData
    .enter()
    .append 'g'
    .attr
      class: 'link'

  link.append 'path'
    .attr
      d: diagonal
    .style
      fill: 'none'
      stroke: (d, i) -> lineColor
      'stroke-width': (d, i) -> strokeRange d.source.distance

  node = treeGroup.selectAll 'g.node'
    .data nodeData
    .enter()
    .append 'g'
    .attr
      class: 'node'
      transform: (d) -> "rotate(#{ d.x / 2 }) translate(#{ d.y })"

  # Add text labels to all nodes that are not groups
  textGroup = (node.filter (d, i) -> not d.group).append 'g'
    .attr 'transform', (d) -> "rotate(#{ if d.x > 180 then 180 else 0 })"

  textGroup.append 'text'
    .text (d) -> d.animalname
    .attr
      'text-anchor': 'middle'
      'dominant-baseline': 'central'
    .style
      fill: 'Black'
      'font-size': '1em'
      'font-family': '"Helvetica Neue",Helvetica,Arial,sans-serif'
    .on 'mouseover', (d) ->
      activeData = this.__data__
      d3.selectAll 'rect.text-background'
        .transition()
          .style 'fill', (d) -> colorSpace colorRange cluster.distance activeData, d
          .style 'stroke', (d) -> colorSpace colorRange cluster.distance activeData, d

  textGroup.each (d, i) ->
    bbox = this.children[0].getBBox()
    (d3.select this).insert 'rect', ':first-child'
      .attr bbox
      .attr
        rx: 4
        class: 'text-background'
      .style
        fill: 'White'
        stroke: 'White'
        'stroke-width': 2

d3.csv 'zoo.csv',
  (error, animals) ->
    treeData = cluster.bottomUpCluster animals
    render()
