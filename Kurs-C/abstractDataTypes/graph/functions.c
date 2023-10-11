typedef struct graph {
    int numnodes;
    bool **edges;
} graph;

graph *create_graph(int numnodes) {
    graph *g = malloc(sizeof(*g));
    if(g == NULL) {
        return NULL;
    }
    g->numnodes = numnodes;
    g->edges = calloc(sizeof(bool*), g->numnodes);
    if(g->edges == NULL) {
        free(g);
        return NULL;
    }

    for(int i=0; i< g->numnodes; i++) {
        g->edges[i] = calloc(sizeof(bool), g->numnodes);
        if(g->edges[i] == NULL) {
            destroy_graph(g);
            return NULL;
        }
    }
    return g;
}

void destroy_graph(graph *g) {
    if(g == NULL) {
        return;
    }
    if(g->edges == NULL) {
        free(g);
        return;
    }

    for(int i=0; i < g->numnodes; i++) {
        if(g->edges[i] != NULL){
            free(g->edges[i]);
        }
    }
    free(g->edges);
    free(g);
}

void print_graph(graph *g){
    if(g == NULL) {
        return;
    }
    printf("Krawedzie:\n");

    for(int from=0; from < g->numnodes; from++) {
        for(int to=0; to < g->numnodes; to++) {
            if(g->edges[from][to]) {
                printf("%d <-> %d\n", from, to);
            }
        }
    }

    printf("\n");
}

bool add_edge(graph *g, int from_node, int to_node) {
    assert(g != NULL);
    assert(from_node < g->numnodes);
    assert(to_node < g->numnodes);
    if(has_edge(g, from_node, to_node)) {
        return false;
    }
    if(from_node != to_node) {
       g->edges[from_node][to_node] = true;
        return true;
    }
    return false;
}

bool has_edge(graph *g, int from_node, int to_node) {
    assert(g != NULL);
    assert(from_node < g->numnodes);
    assert(to_node < g->numnodes);
    return g->edges[from_node][to_node];
}

void print_depth(int depth) {
    for(int i=0; i<depth; i++) {
        printf("| ");
    }
}

bool *traverse(graph *g, int from_node, int this_node, bool visited[], int depth) {
    visited[from_node] = true;
    for(int i=0; i<g->numnodes; i++) {
        if(has_edge(g, from_node, i)) {
            if(!visited[i]) {
                print_depth(depth);
                printf("%d->%d\n", from_node, i);
                traverse(g, i, 0, visited, depth+1);
            }
        }
    }
    return visited;
}

int intergrity(graph *g) {
    int num = g->numnodes;
    bool for_func[num];
    bool copy_func[num];
    for(int i=0; i<num; i++) {
        for_func[i] = 0;
        copy_func[i] = 0;
    }
    int return_value = 0;
    int flag = 0;
    for(int i=0; i<num; i++) {
        flag = 0;
        traverse(g, i, 0, for_func, 0);
        for(int y=0; y<num; y++) {
            if(for_func[y] != copy_func[y]) {
                flag++;
                copy_func[y] = for_func[y];
            }
        }
        if(flag > 0) {
            return_value++;
        }
    }
    return return_value;
}
