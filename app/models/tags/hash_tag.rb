class Tags::HashTag < Tag

  PREFIX = ''
  REGEXP = /(?<=^|(?<=[^a-zA-Z0-9\-\.]))#([A-Za-z0-9]+[\-\_A-Za-z0-9]*)/

end
