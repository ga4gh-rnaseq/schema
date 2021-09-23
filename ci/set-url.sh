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