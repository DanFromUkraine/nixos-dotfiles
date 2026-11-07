    ---
    description: Fast execution mode - minimal planning, no redundant re-validation, no unrequested improvements
    argument-hint: "<task description>"
    ---

    # TASK

    $ARGUMENTS

    # MODE

    FAST EXECUTION MODE.

    The user has explicitly opted out of the heavy planning/validation workflow for this task.
    Speed is the priority. Correctness still matters - but do not spend tool calls proving it twice.

    # RULES

    1. Plan in 2-3 lines maximum. No phase breakdown, no requirement matrix.
    2. Do only what was asked. No unrequested improvements, no comments, no renames, no extra
       structure, no "while we're here" cleanup.
    3. Never re-validate a result that was already validated in this session.
       - If a parse/check/build already passed and the file was not modified afterwards, it is done.
       - Do not re-read a file just written to confirm it was written.
    4. One tool call per step where possible. Never signal a multi-step discovery to a task that
       fits in a single call.
    5. If you already know the file structure from earlier in the session, skip re-reading it.
    6. No cleanup passes. No reverting your own earlier work unless it is broken.
    7. Report the result in the fewest lines that fully answer the question.
       Show the changed region, not the whole file.
    8. Ambiguity: ask one short question if truly blocking, otherwise make the smallest
       reasonable choice and state it in one line.

    # WHAT STILL APPLIES

    - A single verification is expected ONLY if a verification step is cheap and not yet done.
    - Destructive or irreversible actions still require explicit permission.
    - Never claim something passed that was not run.

    # OUTPUT

    Result. Optionally one line: what was checked and the outcome.
    Nothing else.

