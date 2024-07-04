# create .txt files that will later be used to make dictionary title -> bucket

function vector_to_txt(x, file) # include the ".txt" in file
    touch(file);
    io = open(file, "r+");
    for i = 1:length(x)
        write(io, string(x[i]) * (i < length(x) ? "\n" : ""));
    end
    close(io);
end
mkpath("website_name_recovery");
folders(x) = filter(isdir, setdiff(readdir(x), ["System Volume Information"]));

regex_bucket = r"(?<!.)website_name\.to_\d+(001)*-\d+000(?!.)";
buckets = filter(x->occursin(regex_bucket,x), folders("."))

for bucket in buckets
    files = readdir(bucket)
    vector_to_txt(files, joinpath("website_name_recovery", bucket * ".txt"))
end
#= equivalent to:
map(x->vector_to_txt(readdir(x), joinpath("website_name_recovery", x * ".txt")), buckets)
the alternative doesn't really improve the readability though...
=#