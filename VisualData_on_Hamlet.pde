// Based on the Visualizing Data, First Edition.

int nodeCount;
Node[] nodes = new Node[100];
HashMap nodeTable = new HashMap();

int edgeCount;
Edge[] edges = new Edge[300];

static final color nodeColor = #F0C070;
static final color selectColor = #FF3030;
static final color fixedColor = #FF8080;
static final color edgeColor = #757575;

PFont font;

void setup(){
  size(1500, 1000);
  loadData();
  font = createFont("SansSerif", 25);
}

void loadData() {
  String[] lines = loadStrings("Hamlet_act1-1.txt");
  //String[] lines = loadStrings("Hamlet_act1-2.txt");
  //String[] lines = loadStrings("Hamlet_act1-3.txt");
  //String[] lines = loadStrings("Hamlet_act1-4.txt");
  //String[] lines = loadStrings("Hamlet_act1-5.txt");
  //String[] lines = loadStrings("Hamlet_act2-1.txt");
  //String[] lines = loadStrings("Hamlet_act2-2.txt");
  //String[] lines = loadStrings("Hamlet_act3-1.txt");
  //String[] lines = loadStrings("Hamlet_act3-2.txt");
  //String[] lines = loadStrings("Hamlet_act3-3.txt");
  //String[] lines = loadStrings("Hamlet_act3-4.txt");
  //String[] lines = loadStrings("Hamlet_act4-1.txt");
  //String[] lines = loadStrings("Hamlet_act4-2.txt");
  //String[] lines = loadStrings("Hamlet_act4-3.txt");
  //String[] lines = loadStrings("Hamlet_act4-4.txt");
  //String[] lines = loadStrings("Hamlet_act4-5.txt");
  //String[] lines = loadStrings("Hamlet_act4-6.txt");
  //String[] lines = loadStrings("Hamlet_act4-7.txt");
  //String[] lines = loadStrings("Hamlet_act5-1.txt");
  //String[] lines = loadStrings("Hamlet_act5-2.txt");
  
  String line = join(lines, " ");
  
  line = line.replaceAll("--", "\u2014");
  
  String[] phrases = splitTokens(line, ".,;:?!\u2014\"");
  
  for (int i = 0; i < phrases.length; i++){
    String phrase = phrases[i].toLowerCase();
    String[] words = splitTokens(phrase, " ");
    for (int w = 0; w < words.length-1; w++){
      addEdge(words[w], words[w+1]);
    }
  }
}

void addEdge(String fromLabel, String toLabel){
  if (ignoreWord(fromLabel) || ignoreWord(toLabel)){
    return;
  }
  
  Node from = findNode(fromLabel);
  Node to = findNode(toLabel);
  from.increment();
  to.increment();
  
  for (int i = 0; i < edgeCount; i++){
    if (edges[i].from == from && edges[i].to == to){
      edges[i].increment();
      return;
    }
  }
  
  Edge e = new Edge(from, to);
  e.increment();
  if (edgeCount == edges.length){
    edges = (Edge[]) expand(edges);
  }
  edges[edgeCount++] = e;
} 

String[] ignore = {"a", "of", "the", "i", "it", "you", "and", "to"};

boolean ignoreWord(String what){
  for (int i = 0; i < ignore.length; i++){
    if (what.equals(ignore[i])){
      return true;
    }
  }
  return false;
}

Node findNode(String label) {
  label = label.toLowerCase();
  Node n = (Node) nodeTable.get(label);
  if (n == null){
    return addNode(label);
  }
  return n;
}

Node addNode(String label){
  Node n = new Node(label);
  if (nodeCount == nodes.length){
    nodes = (Node[]) expand(nodes);
  }
  nodeTable.put(label, n);
  nodes[nodeCount++] = n;
  return n;
}

void draw(){
  background(255);
  textFont(font);
  smooth();
  
  for (int i = 0; i < edgeCount; i++){
    edges[i].relax();
  }
  
  for (int i = 0; i < nodeCount; i++){
    nodes[i].relax();
  }
  
  for (int i = 0; i < nodeCount; i++){
    nodes[i].update();
  }
  
  for (int i = 0; i < edgeCount; i++){
    edges[i].draw();
  }
  
  for (int i = 0; i < nodeCount; i++){
    nodes[i].draw();
  }
}

Node selection;

void mousePressed(){
  float closest = 20;
  for (int i = 0; i < nodeCount; i++){
    Node n = nodes[i];
    float d = dist(mouseX, mouseY, n.x, n.y);
    if (d < closest){
      selection = n;
      closest = d;
    }
  }
  if (selection != null){
    if (mouseButton == LEFT){
      selection.fixed = true;
    }
    else if (mouseButton == RIGHT){
      selection.fixed = false;
    }
  }
}

void mouseDragged(){
  if (selection != null){
    selection.x = mouseX;
    selection.y = mouseY;
  }
}

void mouseReleased(){
  selection = null;
}
