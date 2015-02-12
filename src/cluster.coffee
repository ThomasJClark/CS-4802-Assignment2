# cluster.coffee: functions for hierarchical clustering using the bottom-up
# agglomerative clustering algorithm.
#
# Thomas Clark - CS 4802 Assignment 2

cluster =
  lowestDistance: 1/0
  highestDistance: 0

  # bottomUpCluster()
  #
  # Perform a bottom-up clustering algorithm by pairing up similar entries
  # two at a time until they form a binary tree.
  bottomUpCluster: (entries) ->
    groupNumber = 1

    while entries.length > 1
      # Find the two entries with the lowest distance
      minNodeDistance = 1/0
      for i in [0 ... entries.length]
        for j in [i + 1 ... entries.length]
          distance = cluster.distance entries[i], entries[j]
          if distance < minNodeDistance
            minNodeDistance = distance
            entryIndex1 = j
            entryIndex2 = i

          # Keep track of the range of distances between entries.  This is used
          # to map distances to colors.
          if distance > cluster.highestDistance
            cluster.highestDistance = minNodeDistance
          if distance < cluster.lowestDistance
            cluster.lowestDistance = minNodeDistance

      # Remove the two entries and add them to a new group
      entry1 = (entries.splice entryIndex1, 1)[0]
      entry2 = (entries.splice entryIndex2, 1)[0]
      entries.push
        animalname: "Group #{ groupNumber++ }"
        group: true
        children: [entry1, entry2]
        distance: minNodeDistance

    # entries should be a binary tree now, so the first (and only) element
    # is the root.
    return entries[0]


  # Because comparing groups involves comparing all of their children, most
  # comparisons end of getting done many times.  Memoizing the distance
  # function dramatically reduces the time it takes to generate the tree.
  _distanceCache: {}


  # distance()
  #
  # Counts the number of properties of entry1 and entry2 that are not equal.
  # If an entry is actually a group, then the distance is the average distance
  # of all of its children.
  distance: (entry1, entry2) ->
    if entry1.animalname > entry2.animalname
      [entry1, entry2] = [entry2, entry1]
    key = "#{ entry1.animalname }, #{ entry2.animalname }"

    d = cluster._distanceCache[key]

    if d isnt undefined
      # If this comparison has already been made, return the previous result
      return d
    else
      if entry1.group
        # Return the average distance of entry2 and all the children of entry1
        totalDistance = (cluster.distance c, entry2 for c in entry1.children)
          .reduce (a, b) -> a + b
        d = totalDistance / entry1.children.length
      else if entry2.group
        # Return the average distance of entry1 and all the children of entry2
        totalDistance = (cluster.distance entry1, c for c in entry2.children)
          .reduce (a, b) -> a + b
        d = totalDistance / entry2.children.length
      else
        # If neither entry1 nor entry2 are groups, then just return the number
        # of fields that they don't have in common (besides 'type')
        d = (entry1[i] isnt entry2[i] and i isnt 'type' for i of entry1)
          .reduce (a, b) -> a + b

      cluster._distanceCache[key] = d
      return d
