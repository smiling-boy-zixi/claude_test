const { test, describe } = require('node:test');
const assert = require('node:assert');
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

describe('Task Status Checker Tests', () => {
  const originalTasksFile = path.join(__dirname, '..', 'dev-tasks.json');
  const backupTasksFile = path.join(__dirname, '..', 'dev-tasks.json.backup');
  const scriptPath = path.join(__dirname, '..', 'scripts', 'check-tasks.js');

  // Backup original file before tests
  const originalContent = fs.readFileSync(originalTasksFile, 'utf8');

  // Test 1: Test task count statistics
  test('should correctly count tasks by status', () => {
    // Create a test tasks file with known data
    const testTasks = {
      tasks: [
        { task_id: 1, status: 'pending' },
        { task_id: 2, status: 'completed' },
        { task_id: 3, status: 'completed' },
        { task_id: 4, status: 'failed' },
        { task_id: 5, status: 'pending' }
      ]
    };

    fs.writeFileSync(originalTasksFile, JSON.stringify(testTasks, null, 2));

    try {
      // Run the script
      const output = execSync(`node ${scriptPath}`, { encoding: 'utf8' });

      // Verify the output contains expected counts
      assert.ok(output.includes('Total Tasks: 5'), 'Should show total of 5 tasks');
      assert.ok(output.includes('Pending: 2'), 'Should show 2 pending tasks');
      assert.ok(output.includes('Completed: 2'), 'Should show 2 completed tasks');
      assert.ok(output.includes('Failed: 1'), 'Should show 1 failed task');
      assert.ok(output.includes('40%'), 'Should show 40% progress (2/5)');
    } finally {
      // Restore original file
      fs.writeFileSync(originalTasksFile, originalContent);
    }
  });

  // Test 2: Test empty task list handling
  test('should handle empty task list correctly', () => {
    // Create an empty tasks file
    const testTasks = { tasks: [] };

    fs.writeFileSync(originalTasksFile, JSON.stringify(testTasks, null, 2));

    try {
      // Run the script
      const output = execSync(`node ${scriptPath}`, { encoding: 'utf8' });

      // Verify the output handles empty list correctly
      assert.ok(output.includes('Total Tasks: 0'), 'Should show 0 total tasks');
      assert.ok(output.includes('Pending: 0'), 'Should show 0 pending tasks');
      assert.ok(output.includes('Completed: 0'), 'Should show 0 completed tasks');
      assert.ok(output.includes('Failed: 0'), 'Should show 0 failed tasks');
      assert.ok(output.includes('0%'), 'Should show 0% progress for empty list');
    } finally {
      // Restore original file
      fs.writeFileSync(originalTasksFile, originalContent);
    }
  });
});