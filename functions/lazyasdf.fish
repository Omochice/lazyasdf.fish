function lazyasdf --argument-names subcommand language --description "Use asdf lazily by using fzf"
  for arg in $argv
    if test $arg = "-h" || test $arg = "--help"
      echo "lazyasdf Use asdf lazily by using fzf"
      echo
      echo "Usage: lazyasdf {subcommand} [language]"
      echo "    subcommand: The one of bellow"
      echo "        - install"
      echo "        - global"
      echo "        - local"
      echo "    language: Name of installed plugin"
      return
    end
  end

  if test -z $subcommand
    echo "You must specify subcommand"
    return 2
  end

  if test -z $language
    set --function language (asdf plugin list | fzf --no-sort --tac --multi --height=30%)
    if test -z $language
      return 2
    end
  end

  switch $subcommand
    case install
      set --function selected (asdf list-all $language | fzf --no-sort --tac --multi --height=30% )
    case local global
      set --function selected (asdf list $language | sed -e "s/^\s*\**//g" | fzf --no-sort --tac --multi --height=30%)
  end
  if test -z $selected
    return 2
  end
  asdf $subcommand $language $selected
end
