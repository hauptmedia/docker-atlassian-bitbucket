docker run --volumes-from atlassian-stash-data --name="atlassian-stash" -d -p 7990:7990 -p 7999:7999 hauptmedia/atlassian-stash

docker run -d --name="atlassian-stash-data" hauptmedia/atlassian-stash-data
