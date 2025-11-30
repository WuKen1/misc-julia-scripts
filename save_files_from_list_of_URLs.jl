using Downloads

function download(args...)
	sleep(3) # pause for 3 seconds between downloads
	Downloads.download(args...);
end

folder_name = "sakuga"
directory_path = joinpath(raw"C:\Users\Username\Pictures_local", folder_name)

# create folder if it doesn't already exist
isdir(directory_path) ? nothing : mkpath(directory_path)

cd(directory_path)

# https://www.sakugabooru.com/post/show/108301
# https://www.sakugabooru.com/post/show/272185
bulk_URLs = "https://www.sakugabooru.com/data/1cd9d9d176f436e4a467bbe5d24393fe.mp4
https://www.sakugabooru.com/data/e69783ee0abcb8e2bad6f3402a8031d7.mp4"

URLs = split(bulk_URLs, '\n') .|> String

filenames = URLs .|> splitdir .|> last

print("\033c") # clear REPL

map(download, URLs, filenames);

# this is how the `download` function would be called
# on a single URL and filename:
#

# download(URLs[1], filenames[1])
