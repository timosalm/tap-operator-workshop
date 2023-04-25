kubectl() {
    if [[ $@ == *"secret"* ]]; then
        command echo "No resources found in $SESSION_NAMESPACE namespace."
    else
        command kubectl "$@"
    fi
}