#!/bin/bash

curl -H "Content-Type: application/json" -XPUT "http://localhost:9200/_template/log" -d'
{
  "index_patterns": ["logs-*"],
  "version": 1,
  "settings": {
    "index.refresh_interval": "3s"
  },
  "mappings": {
      "dynamic_templates": [
        {
          "map_mdc": {
            "path_match": "mdc.*",
            "mapping": {
              "type": "keyword",
              "norms": false
            }
          }
        },
        {
          "map_ctx": {
            "path_match": "ctx.*",
            "match_mapping_type": "string",
            "mapping": {
              "type": "keyword",
              "norms": false
            }
          }
        }
      ],
      "properties": {
        "@timestamp": {"type": "date"},
        "@trace": {"type": "keyword", "ignore_above":  128},
        "subsystem": {"type": "keyword", "ignore_above":  64},
        "thread": {"type": "keyword", "ignore_above":  64},
        "lvl": {"type": "keyword", "ignore_above":  16},
        "logger": {"type": "keyword", "ignore_above":  128},
        "marker": {
            "type": "text",
            "norms": false,
            "analyzer": "standard",
            "fields": {
                "keyword": {
                    "type":  "keyword", "ignore_above": 64
                }
            }
        },
        "msg": {
            "type": "text",
            "norms": false,
            "index_options": "offsets",
            "fields": {
                "keyword": {
                    "type":  "keyword", "ignore_above": 256
                }
            }
        },
        "ctx": {
          "type": "object"
        },
        "mdc": {
          "type": "object"
        },
        "thrown": {
          "dynamic": false,
          "properties": {
            "cls": {"type": "keyword", "ignore_above":  128},
            "msg": {
                "type": "text",
                "norms": false,
                "fields": {
                    "keyword": {
                        "type": "keyword", "ignore_above": 256
                    }
                }
            },
            "stack": {
                "type": "keyword",
                "ignore_above": 32768,
                "norms": false,
                "index": false
            },
            "hash": {"type": "keyword", "ignore_above": 64}
          }
        },
        "log": {
          "dynamic": false,
          "properties": {
            "host": {"type": "keyword", "ignore_above": 64},
            "src": {"type": "keyword", "ignore_above": 256}
          }
        }
      }
  }
}'
