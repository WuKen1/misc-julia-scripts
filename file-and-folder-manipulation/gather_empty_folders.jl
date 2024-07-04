# moves all empty folders in working directory into a new folder

println("type in directory (leave blank for current directory):")
dir = readline();
cd(isempty(dir) ? "." : dir);

folders(x) = filter(isdir, setdiff(readdir(x), ["System Volume Information"]));
empty_folders = filter(x->isempty(readdir(x)), folders("."));

mkpath("empty_folders");

for folder in empty_folders
    src = folder;
    dst = joinpath("empty_folders", folder);
    try
        mv(src, dst)
    catch e
        println("something went wrong with:\n$folder\n$e\n");
    end
end
#= would be equivalent to
map(x -> mv(x, joinpath("empty_folders", x)), empty_folders)
if it weren't for the need to handle errors
=#