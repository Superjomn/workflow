# Load directory-local variables
function load_dir_vars
    set -l dir (pwd)
    while test $dir != $HOME -a -d $dir
        set -l dir_vars_file $dir/.dir_vars.fish
        if test -f $dir_vars_file
            echo "update local-dir data: $dir_vars_file"
            source $dir_vars_file
            return
        end
        echo "no local-dir data .."
        # Move up one directory
        set dir (dirname $dir)
    end
end

# override cd command to load directory-local variables
function cd
    builtin cd $argv
    load_dir_vars
end

# get git branch name
function git-branch-name
    git rev-parse --abbrev-ref HEAD
end

function git-pre-commit
    git add -u
    pre-commit
end

# depend on the following variables
# - $GIT_DEFAULT_BRANCH, such as "main"
# - $GIT_DEFAULT_REMOTE, such as "origin"
function git-update-code
    git fetch $GIT_DEFAULT_REMOTE $GIT_DEFAULT_BRANCH
    git remote prune $GIT_DEFAULT_REMOTE
    git checkout $GIT_DEFAULT_REMOTE/$GIT_DEFAULT_BRANCH
end