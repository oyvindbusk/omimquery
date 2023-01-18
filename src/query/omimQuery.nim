import httpClient
import strformat
import json
import strutils
import asyncdispatch
import sequtils
export json

var apiKey = "KywhOGCsQG6agsmAct0KEg"
#var genenames: seq[string] = @["sod1", "gjb1", "", "setx"]

proc cleanGeneList(genes: seq[string]): seq[string] =
  var cleanedGenes: seq[string] = genes
  if len(cleanedGenes) > 1 and cleanedGenes.find("") != -1:
    cleanedGenes.delete(cleanedGenes.find(""))
  return cleanedGenes


proc parseOmimResults*(input: JsonNode, gene: string): seq[JsonNode] =
    var phenotypeMapList: seq[JsonNode] # list for storing phenotypes
    var genes: seq[string]
    for i in input["omim"]["searchResponse"]["entryList"]:
        try:
            genes = i["entry"]["geneMap"]["geneSymbols"].getStr().replace(" ","").split(",")
            apply(genes, toLower)
            if i["entry"].hasKey("geneMap") and genes.contains(gene.toLower()):
                
                for p in i["entry"]["geneMap"]["phenotypeMapList"]:
                    phenotypeMapList.add(%*{"symbols": i["entry"]["geneMap"]["geneSymbols"], "genename": i["entry"]["geneMap"]["geneName"] , "mim": p["phenotypeMap"]["mimNumber"], "name": p["phenotypeMap"]["phenotype"], "inheritance": p["phenotypeMap"]["phenotypeInheritance"]})
        except:
            echo gene & ": not found"
    return phenotypeMapList


proc queryOmim*(s: seq[string]): JsonNode = # Returns list of json for each gene
    var q: string
    var client = newHttpClient()
    var jsonResp: JsonNode
    var listOfJsons: seq[JsonNode]
    var returnJson: JsonNode

    var genes = cleanGeneList(s)
    for gene in genes:
        client = newHttpClient()
        q = fmt"https://api.omim.org/api/entry/search?search={gene}&include=geneMap&format=json&apiKey={apiKey}&start=0&limit=1000"
        jsonResp = parseJson(client.getContent(q))
        listOfJsons.add(parseOmimResults(jsonResp, gene))
    returnJson = %*{"data": listOfJsons}
    return returnJson

#echo pretty(queryOmim(genenames))
#   https://api.omim.org/api/entry/search?search=MSTN&include=geneMap&format=json&apiKey=KywhOGCsQG6agsmAct0KEg&start=0&limit=1000