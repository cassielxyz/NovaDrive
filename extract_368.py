import json
import re

with open(r'C:\Users\jesow\.gemini\antigravity-ide\brain\3e5a250c-4ae2-469c-9cc5-58d112538e71\.system_generated\logs\transcript.jsonl', encoding='utf-8') as f:
    for line in f:
        if '"step_index":368' in line:
            data = json.loads(line)
            content = data.get('content', '')
            # The content looks like:
            # Created At...
            # File Path...
            # ...
            # 1: import 'dart:math';
            # 2: ...
            
            lines = content.split('\n')
            code_lines = []
            for l in lines:
                match = re.match(r'^(\d+):\s(.*)$', l)
                if match:
                    code_lines.append(match.group(2))
            
            with open(r'c:\Users\jesow\Documents\github projects\nova drive\lib\features\splash\splash_screen.dart', 'w', encoding='utf-8') as out:
                out.write('\n'.join(code_lines) + '\n')
            print("Successfully extracted step 368 to splash_screen.dart")
            break
