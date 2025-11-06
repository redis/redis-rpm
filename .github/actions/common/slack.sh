#!/bin/bash

slack_format_success_message() {
jq --arg release_tag "$1" --arg url_prefix "$2" --arg footer "$3" --arg env "$4" '
{
  "icon_emoji": ":redis-circle:",
  "text": (":redhat: RPM Packages Published for Redis: " + $release_tag + " (" + $env + ")"),
  "blocks": (
    [
      {
        "type": "header",
        "text": { "type": "plain_text", "text": (":redhat: RPM Packages Published for Release " + $release_tag + " (" + $env + ")") }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "The following packages have been published:"
        }
      }
    ] +
    (
      to_entries
      | map(
          .key as $dist | .value | to_entries
          | map(
              .key as $platform | .value as $packages |
              {
                "type": "section",
                "text": {
                  "type": "mrkdwn",
                  "text": (
                    "Distribution: *" + $dist + "* (" + $platform + ")\n" +
                    (
                      $packages
                      | map("• <" + $url_prefix + "/" + $dist + "/" + $platform + "/" + . + "|" + . + ">")
                      | join("\n")
                    )
                  )
                }
              }
            )
        )
      | flatten
    ) +
    [
      {
        "type": "context",
        "elements": [
          { "type": "mrkdwn", "text": $footer }
        ]
      }
    ]
  )
}'
}

slack_format_failure_message() {
    header=$1
    workflow_url=$2
    footer=$3
    if [ -z "$header" ]; then
        header=" "
    fi
    if [ -z "$footer" ]; then
        footer=" "
    fi

# Create Slack message payload
    cat << EOF
{
"icon_emoji": ":redis-circle:",
"text": "$header",
"blocks": [
    {
    "type": "header",
    "text": {
        "type": "plain_text",
        "text": "❌  $header"
    }
    },
    {
    "type": "section",
    "text": {
        "type": "mrkdwn",
        "text": "Workflow run: $workflow_url"
    }
    },
    {
    "type": "context",
    "elements": [
        {
        "type": "mrkdwn",
        "text": "$footer"
        }
    ]
    }
]
}
EOF
}

