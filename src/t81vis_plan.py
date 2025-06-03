import re
import argparse
import graphviz
import plotly.graph_objects as go
from pathlib import Path

def parse_trace_log(logfile):
    """Parse trace log into a list of trace dictionaries."""
    traces = []
    try:
        with open(logfile, 'r') as f:
            for line in f:
                if line.startswith('[TRACE]'):
                    match = re.match(r'\[TRACE\] type=(\w+) value=(.+?) state=(.+?)(?: score=([\d.]+))?(?: session=([^\s]+))?', line)
                    if match:
                        trace = {
                            'type': match[1],
                            'value': match[2],
                            'state': match[3],
                            'score': float(match[4]) if match[4] else None,
                            'session': match[5] if match[5] else 'default',
                            'index': len(traces)  # Track order
                        }
                        traces.append(trace)
    except FileNotFoundError:
        print(f"Error: Log file '{logfile}' not found")
        return []
    except Exception as e:
        print(f"Error parsing log: {e}")
        return []
    return traces

def get_color(trace_type, score):
    """Return node color based on type or score."""
    base_colors = {
        'reflect': 'lightblue',
        'simulate': 'lightgreen',
        'maximize': 'gold',
        'plan': 'orange',
        'learn': 'violet',
        'dream': 'pink',
        'replay': 'gray',
        'score': 'lightgray',
        'execute': 'cyan',
        'branch': 'yellow',
        'complete': 'purple'
    }
    if score is not None:
        # Normalize score (0–2.8 typical from planner.cweb)
        clamped = max(0.0, min(score / 2.8, 1.0))
        red = int((1.0 - clamped) * 255)
        green = int(clamped * 255)
        return f"#{red:02x}{green:02x}80"
    return base_colors.get(trace_type, 'white')

def build_plan_tree(traces, use_plotly=False):
    """Build a ternary plan tree, supporting Graphviz or Plotly output."""
    if use_plotly:
        return build_plotly_tree(traces)
    
    dot = graphviz.Digraph(comment="T81 Plan Trace", graph_attr={'rankdir': 'TB'})
    nodes = {}
    edges = []

    for trace in traces:
        node_id = f"node{trace['index']}"
        label = f"{trace['type']}\\n{trace['value'][:48]}\\n[{trace['state']}]"
        if trace['score'] is not None:
            label += f"\\nScore: {trace['score']:.2f}"
        dot.node(node_id, label, style='filled', fillcolor=get_color(trace['type'], trace['score']))
        nodes[trace['index']] = {'id': node_id, 'state': trace['state'], 'type': trace['type']}

    # Infer ternary branching based on state and type
    for i, trace in enumerate(traces):
        if i == 0:
            continue
        parent_idx = None
        # Find parent: prefer 'branch' or 'plan' nodes with matching state
        for j in range(i - 1, -1, -1):
            if traces[j]['state'] == trace['state'] and traces[j]['type'] in ('branch', 'plan', 'goal'):
                parent_idx = j
                break
        if parent_idx is None:
            parent_idx = i - 1  # Fallback to previous node
        edges.append((nodes[parent_idx]['id'], nodes[i]['id']))

    for parent_id, child_id in edges:
        dot.edge(parent_id, child_id)

    return dot

def build_plotly_tree(traces):
    """Build an interactive Plotly tree visualization."""
    nodes = []
    x_coords = []
    y_coords = []
    edges_x = []
    edges_y = []
    hover_texts = []

    # Assign coordinates for ternary tree
    for i, trace in enumerate(traces):
        depth = min(i // 3, 5)  # Limit depth for readability
        x = (i % 3 - 1) * (1 / (depth + 1))  # Spread horizontally
        y = -depth  # Stack vertically
        x_coords.append(x)
        y_coords.append(y)
        label = f"{trace['type']}: {trace['value'][:24]}<br>State: {trace['state']}"
        if trace['score'] is not None:
            label += f"<br>Score: {trace['score']:.2f}"
        hover_texts.append(label)
        nodes.append({'id': i, 'state': trace['state'], 'type': trace['type']})

    # Build edges
    for i in range(1, len(traces)):
        parent_idx = None
        for j in range(i - 1, -1, -1):
            if traces[j]['state'] == traces[i]['state'] and traces[j]['type'] in ('branch', 'plan', 'goal'):
                parent_idx = j
                break
        if parent_idx is None:
            parent_idx = i - 1
        edges_x.extend([x_coords[parent_idx], x_coords[i], None])
        edges_y.extend([y_coords[parent_idx], y_coords[i], None])

    # Create Plotly figure
    edge_trace = go.Scatter(
        x=edges_x, y=edges_y,
        line=dict(width=1, color='black'),
        hoverinfo='none',
        mode='lines'
    )

    node_trace = go.Scatter(
        x=x_coords, y=y_coords,
        mode='markers+text',
        text=[t['type'] for t in traces],
        textposition='bottom center',
        marker=dict(
            size=20,
            color=[get_color(t['type'], t['score']) for t in traces],
            line=dict(width=1, color='black')
        ),
        hovertext=hover_texts,
        hoverinfo='text'
    )

    fig = go.Figure(data=[edge_trace, node_trace],
                    layout=go.Layout(
                        title='T81 Plan Trace',
                        showlegend=False,
                        hovermode='closest',
                        margin=dict(b=20, l=5, r=5, t=40),
                        xaxis=dict(showgrid=False, zeroline=False, showticklabels=False),
                        yaxis=dict(showgrid=False, zeroline=False, showticklabels=False)
                    ))

    return fig

def visualize_plan(logfile, output_file='plan', format='svg', use_plotly=False):
    """Visualize plan traces as a ternary tree."""
    traces = parse_trace_log(logfile)
    if not traces:
        print("No traces found to visualize")
        return

    if use_plotly:
        fig = build_plan_tree(traces, use_plotly=True)
        fig.write_html(f"{output_file}.html", auto_open=True)
    else:
        dot = build_plan_tree(traces)
        dot.render(output_file, format=format, view=True)

def main():
    parser = argparse.ArgumentParser(description="Visualize HanoiVM AGI plan traces")
    parser.add_argument('--logfile', default='/var/log/axion/trace.t81log', help='Path to trace log file')
    parser.add_argument('--output', default='plan', help='Output file name (without extension)')
    parser.add_argument('--format', choices=['svg', 'png', 'pdf'], default='svg', help='Output format (Graphviz only)')
    parser.add_argument('--plotly', action='store_true', help='Use Plotly for interactive HTML output')
    args = parser.parse_args()

    visualize_plan(args.logfile, args.output, args.format, args.plotly)

if __name__ == '__main__':
    main()
