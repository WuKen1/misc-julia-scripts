println("type in directory (leave blank for current directory):");
dir = readline();
cd(isempty(dir) ? "." : dir);

img_formats = Set([".apng", ".avif", ".gif", ".jpg", ".jpeg",
    ".jfif", ".pjpeg", ".pjp", ".png", ".svg", ".webp", ".bmp",
    ".ico", ".tiff",]);

vid_formats = Set([".mpeg-2", ".mp4", ".mov", ".wmv", ".avi", 
    ".avchd", ".flv", ".f4v", ".swf", ".webm", ".html5", ".mkv",])

##get_extension(file) = file[findlast('.', file):end];
get_extension(file) = splitext(file)[2];
folders(x) = filter(isdir, readdir(x));

for folder in folders(".")
    img_count = 0;
    vid_count = 0;
    for (~, ~, files) in walkdir(folder)
        for file in files
            ext = lowercase(get_extension(file));
            if ext in img_formats
                img_count += 1;
            end
            if ext in vid_formats
                vid_count += 1;
            end
        end
    end
    if img_count > 0
        println("$img_count images in $folder");
    end
    if vid_count > 0
        println("$vid_count videos in $folder");
    end
end