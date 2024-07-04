regex_author = r"(?<!.)\[[^\[\]]+\]\s";
regex_bucket = r"(?<!.)anchira\.to_\d+(001)*-\d+000(?!.)";
folders(x) = filter(isdir, setdiff(readdir(x), ["System Volume Information"]));
buckets = filter(x->occursin(regex_bucket,x), folders("."))

for bucket in buckets
    files = readdir(bucket)
    for file in files
        author = match(regex_author, file);
        isnothing(author) && continue # skip over if unable to parse author from file

        author = chop(author.match, head=1, tail=2); # remove brackets and trailing whitespace
        mkpath(joinpath("anchira", author)); # make folder
        mv(joinpath(bucket, file), joinpath("anchira", author, file); force=true); # move file to appropriate folder
    end
end

#=
for (root, dirs, files) in walkdir(".")
    ~occursin(regex_bucket, basename(root)) && continue # skip over if not "bucket"
    for file in files
        author = match(regex_author, file);
        isnothing(author) && continue # skip

        author = chop(author.match, head=1, tail=2); # remove brackets and trailing whitespace
        mkpath(joinpath("anchira", author)); # make folder
        mv(joinpath(root, file), joinpath("anchira", author, file)); # move file to appropriate folder
    end
end
=#