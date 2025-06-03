import re
import graphviz

def parse_trace_log(logfile):
    traces = []
    with open(logfile, 'r') as f:
        for line in f:
            if line.startswith('[TRACE]'):
                match = re.match(r'\[TRACE\] type=(\w+) value=(.+) state=(.+?)(?: score=([\d.]+))?', line)
                if match:
                    trace = {
                        'type': match[1],
                        'value': match[2],
                        'state': match[3],
                        'score': float(match[4]) if match[4] else None
                    }
                    traces.append(trace)
    return traces

def get_color(trace_type, score):
    # Use type color as fallback
    base_colors = {
        'reflect': 'lightblue',
        'simulate': 'lightgreen',
        'maximize': 'gold',
        'plan': 'orange',
        'learn': 'violet',
        'dream': 'pink',
        'replay': 'gray',
    }
    if score is not None:
        # Convert score to red (low) → green (high)
        clamped = max(0.0, min(score / 2.0, 1.0))  # normalize to 0–1
        red = int((1.0 - clamped) * 255)
        green = int(clamped * 255)
        return f"#{red:02x}{green:02x}80"  # semi-transparent
    return base_colors.get(trace_type, 'white')

def build_plan_tree(traces):
    dot = graphviz.Digraph(comment="T81 Plan Trace")
    parent_stack = []

    for i, trace in enumerate(traces):
        node_id = f"node{i}"
        label = f"{trace['type']}\\n{trace['value'][:24]}\\n[{trace['state']}]"
        if trace['score'] is not None:
            label += f"\\nScore: {trace['score']:.2f}"
        dot.node(node_id, label, style='filled', fillcolor=get_color(trace['type'], trace['score']))

        # Link to parent (last node in stack)
        if parent_stack:
            parent_id = parent_stack[-1]['id']
            dot.edge(parent_id, node_id)

        parent_stack.append({'id': node_id, 'state': trace['state']})

    return dot

def visualize_plan(logfile, output_file='plan'):
    traces = parse_trace_log(logfile)
    dot = build_plan_tree(traces)
    dot.render(output_file, format='svg', view=True)

if __name__ == '__main__':
    visualize_plan('/var/log/axion/trace.t81log')
