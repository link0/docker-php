function array(x) {
    x[0] = 0;
}

function push(arr, item) {
    arr[++arr[0]] = item;
}

function last(arr) {
    return arr[arr[0]];
}

function pop(arr) {
    delete arr[arr[0]];
    arr[0]--;
}

function join(arr, glue) {
    str="";
    if (arr[0] > 0) {
       str=arr[1];
    }
    for (i = 2; i <= arr[0]; ++i) {
        str=str glue arr[i]; 
    }
    return str
}

BEGIN {
    COMPARATOR["gt"]="gt"
    COMPARATOR[">"]="gt"
    COMPARATOR["="]="eq"
    COMPARATOR["eq"]="eq"
    COMPARATOR["lt"]="lt"
    COMPARATOR["<"]="lt"
    COMPARATOR["gte"]="gte"
    COMPARATOR[">="]="gte"
    COMPARATOR["lte"]="lte"
    COMPARATOR["<="]="lte"
    array(IF_DEPTH)
    push(IF_DEPTH, 1)
}

$0 ~ /^#if/ {
    array(tokens)

    for (i = 2; i <= NF; ++i) {
        token=$i;
        
        if (token in COMPARATOR) {
            ++i
            switch (COMPARATOR[token]) {
                case "gt":
                    push(tokens, PHP_VERSION > $i ? 1 : 0);
                    break;
                case "lt":
                    push(tokens, PHP_VERSION < $i ? 1 : 0);
                    break;
                case "eq":
                    push(tokens, PHP_VERSION == $i ? 1 : 0);
                    break;
                case "gte":
                    push(tokens, PHP_VERSION >= $i ? 1 : 0);
                    break;
                case "lte":
                    push(tokens, PHP_VERSION <= $i ? 1 : 0);
                    break;
            }
            continue;
        }

        if (token == "and" || token == "or") {
            push(tokens, token)
            continue;
        }

        print "Unknown token: " token;
        exit 1;
    }

    is_ok=tokens[1];
    for (i = 2; i <= tokens[0]; ++i) {
        combinator=tokens[i];

        ++i;
        
        if ("and" == combinator) {
            is_ok=and(is_ok, tokens[i])
        }

        if ("or" == combinator) {
            is_ok=or(is_ok, tokens[i])
        }
    }

    push(IF_DEPTH, and(is_ok, last(IF_DEPTH)));
    next;
}

$0 ~ /#endif/ {
    pop(IF_DEPTH);
    next;
}

$0 ~ /PHPVERSION/ {
    gsub("PHPVERSION", PHP_VERSION);    
}

last(IF_DEPTH) == 1 { print $0 }
