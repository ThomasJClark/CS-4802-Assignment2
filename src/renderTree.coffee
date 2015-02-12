# renderTree.coffee: main rendering functions for assignment 2.
#
# Thomas Clark - CS 4802 Assignment 2

renderTree =
  _tree:
    d3.layout.tree()
      .size [360, 700]
      .value (d) -> d.animalname
      .children (d) -> d.children
      .separation (a, b) -> 2 / a.depth

  _colorSpace: d3.interpolateRgb '#FF3341', '#FBD2D4'

  _lineColor: '#CCB8BA'

  _diagonal:
      d3.svg.diagonal.radial()
        .projection (d) -> [d.y, (d.x + 180) / 180 * Math.PI / 2]

  _treeGroup: svg.append 'g'
    .attr 'transform', 'translate(640, 70)'

  # render()
  #
  # Draw the tree as an SVG
  render: (treeData) ->
    nodeData = renderTree._tree.nodes treeData
    linkData = renderTree._tree.links nodeData

    colorRange = d3.scale.linear()
      .domain [cluster.lowestDistance, cluster.highestDistance]
      .range [0, 1]

    strokeRange = d3.scale.linear()
      .domain [cluster.lowestDistance, cluster.highestDistance]
      .range [10, 1]

    # Render links as paths
    link = (renderTree._treeGroup.selectAll 'g.link').data linkData
    link.exit().remove()
    link.enter().append 'g'
      .attr 'class', 'link'

    link.append 'path'
      .attr
        d: renderTree._diagonal
      .style
        fill: 'none'
        stroke: (d, i) -> renderTree._lineColor
        'stroke-width': (d, i) -> strokeRange d.source.distance

    # Render nodes as groups containing a text element and a rect element
    node = (renderTree._treeGroup.selectAll 'g.node').data nodeData
    console.log node.exit()
    node.exit().remove()
    node.enter().append 'g'
      .attr
        class: 'node'
        transform: (d) -> "rotate(#{ d.x / 2 }) translate(#{ d.y })"

    # Add text labels only to nodes that are not groups
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
            .style 'fill', (d) -> renderTree._colorSpace colorRange cluster.distance activeData, d
            .style 'stroke', (d) -> renderTree._colorSpace colorRange cluster.distance activeData, d

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
