import jester
import query/omimQuery
import httpClient
import json
import strutils
include "../tmpl/main.tmpl"


routes:
  get "/":
    resp genMain()


  get "/api":
    var genes = @"genes" # input from text-field

    var response: JsonNode
    if len(genes) != 0:
      var genenames: seq[string] = genes.split("\n")
      var x: JsonNode = queryOmim(genenames)
      response = x
      resp response
    else:
      response = %* {"data": [{"genename": "No", "symbols": "Genes", "mim": "Entered", "name": "In", "inheritance": "Searchbox"}]}
      resp response
