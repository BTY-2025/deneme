const express = require('express');
const mysql = require('mysql2/promise');

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

const pool = mysql.createPool({
  host: '5.39.8.160',
  port: 3306,
  user: 'flywork1_pdfologyUser',
  password: 'YlNlO?xaZnCQ1CBA',
  database: 'flywork1_pdfology',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

const asyncHandler = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};

app.get('/', (req, res) => {
  res.json({
    message: 'PDF AI Reader Admin Panel API is running.',
    endpoints: {
      users: 'GET /panel/users - All users and metrics',
      userDetails: 'GET /panel/users/:uid/details - Specific user uploads & action logs',
      uploads: 'GET /panel/uploads - Chronological file uploads',
      actions: 'GET /panel/actions - Chronological user actions'
    }
  });
});

app.get('/panel/users', asyncHandler(async (req, res) => {
  const query = `
    SELECT 
      u.firebase_uid, 
      u.is_premium, 
      u.last_seen,
      COUNT(DISTINCT up.id) AS total_pdfs_uploaded,
      COUNT(DISTINCT ua.id) AS total_actions_performed
    FROM users u
    LEFT JOIN user_uploads up ON u.firebase_uid = up.firebase_uid
    LEFT JOIN user_actions ua ON u.firebase_uid = ua.firebase_uid
    GROUP BY u.firebase_uid, u.is_premium, u.last_seen
    ORDER BY u.last_seen DESC;
  `;
  
  const [rows] = await pool.query(query);
  res.json({
    status: 'success',
    count: rows.length,
    data: rows.map(row => ({
      firebase_uid: row.firebase_uid,
      is_premium: !!row.is_premium,
      last_seen: row.last_seen,
      total_pdfs_uploaded: Number(row.total_pdfs_uploaded),
      total_actions_performed: Number(row.total_actions_performed)
    }))
  });
}));

app.get('/panel/users/:uid/details', asyncHandler(async (req, res) => {
  const { uid } = req.params;

  const userQuery = 'SELECT firebase_uid, is_premium, last_seen FROM users WHERE firebase_uid = ?';
  const [userRows] = await pool.query(userQuery, [uid]);

  if (userRows.length === 0) {
    return res.status(404).json({
      status: 'error',
      message: `User with UID '${uid}' not found.`
    });
  }

  const user = userRows[0];

  const uploadsQuery = 'SELECT id, file_name, file_size, uploaded_at FROM user_uploads WHERE firebase_uid = ? ORDER BY uploaded_at DESC';
  const [uploadRows] = await pool.query(uploadsQuery, [uid]);

  const actionsQuery = 'SELECT id, action_type, details, performed_at FROM user_actions WHERE firebase_uid = ? ORDER BY performed_at DESC';
  const [actionRows] = await pool.query(actionsQuery, [uid]);

  res.json({
    status: 'success',
    data: {
      profile: {
        firebase_uid: user.firebase_uid,
        is_premium: !!user.is_premium,
        last_seen: user.last_seen
      },
      uploads: uploadRows.map(row => ({
        id: row.id,
        file_name: row.file_name,
        file_size_bytes: row.file_size,
        uploaded_at: row.uploaded_at
      })),
      actions: actionRows.map(row => ({
        id: row.id,
        action_type: row.action_type,
        details: row.details,
        performed_at: row.performed_at
      }))
    }
  });
}));

app.get('/panel/uploads', asyncHandler(async (req, res) => {
  const query = `
    SELECT up.id, up.firebase_uid, up.file_name, up.file_size, up.uploaded_at, u.is_premium 
    FROM user_uploads up
    LEFT JOIN users u ON up.firebase_uid = u.firebase_uid
    ORDER BY up.uploaded_at DESC;
  `;
  const [rows] = await pool.query(query);
  res.json({
    status: 'success',
    count: rows.length,
    data: rows.map(row => ({
      id: row.id,
      firebase_uid: row.firebase_uid,
      is_premium: !!row.is_premium,
      file_name: row.file_name,
      file_size_bytes: row.file_size,
      uploaded_at: row.uploaded_at
    }))
  });
}));

app.get('/panel/actions', asyncHandler(async (req, res) => {
  const query = `
    SELECT ua.id, ua.firebase_uid, ua.action_type, ua.details, ua.performed_at, u.is_premium
    FROM user_actions ua
    LEFT JOIN users u ON ua.firebase_uid = u.firebase_uid
    ORDER BY ua.performed_at DESC;
  `;
  const [rows] = await pool.query(query);
  res.json({
    status: 'success',
    count: rows.length,
    data: rows.map(row => ({
      id: row.id,
      firebase_uid: row.firebase_uid,
      is_premium: !!row.is_premium,
      action_type: row.action_type,
      details: row.details,
      performed_at: row.performed_at
    }))
  });
}));

app.use((err, req, res, next) => {
  console.error('API Error:', err);
  res.status(500).json({
    status: 'error',
    message: err.message || 'Internal Server Error'
  });
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
