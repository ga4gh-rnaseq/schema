export URL_START="https://raw.githubusercontent.com/ga4gh-rnaseq/schema/gh-pages/"
export URL_END="openapi.yaml"

export URL_BRANCH=$(
    if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
        if [ "$TRAVIS_BRANCH" = "master" ]; then
            echo "";
        else
            echo "preview/${TRAVIS_BRANCH}/";
        fi;
    else
        echo "preview/${TRAVIS_PULL_REQUEST_BRANCH}/";
    fi
)

export URL_TO_VALIDATE="${URL_START}${URL_BRANCH}${URL_END}"
