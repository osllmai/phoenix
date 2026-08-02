'use client';

import { useState } from 'react';

import CompareMerge from './CompareMerge';
import LaneGrid from './LaneGrid';
import WorktreeRail from './WorktreeRail';
import { DIFF_FILES, PICK_OPTIONS } from './sampleData';
import s from '../page.module.css';

export default function FleetWorkspace() {
  const [winnerPath, setWinnerPath] = useState(PICK_OPTIONS[0].path);
  const [fileKey, setFileKey] = useState(DIFF_FILES[0].key);
  const [focused, setFocused] = useState<string | null>(null);

  return (
    <div className={s.split}>
      <WorktreeRail winnerPath={winnerPath} />
      <div className={s.work}>
        <LaneGrid focused={focused} onFocus={setFocused} />
        <CompareMerge
          winnerPath={winnerPath}
          onPick={setWinnerPath}
          fileKey={fileKey}
          onFile={setFileKey}
        />
      </div>
    </div>
  );
}
