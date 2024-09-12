const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid'); // Import uuid

// Setup express app
const app = express();
app.use(express.json());
app.use(cors());

// MongoDB Connection
mongoose.connect('mongodb+srv://krisha10:Krisha.10@wellnessapp.5tpaq.mongodb.net/', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// User Schema
const userSchema = new mongoose.Schema({
  userId: { type: String, unique: true }, // Add userId field
  name: String,
  email: { type: String, unique: true },
  password: String,
  age: Number,
  gender: String,
  mobileNumber: String,
});

// Create User model
const User = mongoose.model('User', userSchema);

// Register API 
app.post('/api/register', async (req, res) => {
  const { name, email, password, age, gender, mobileNumber } = req.body;

  try {
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Generate userId using uuid
    const userId = uuidv4();

    // Create new user
    const user = new User({
      userId, // Assign userId
      name,
      email,
      password: hashedPassword,
      age,
      gender,
      mobileNumber,
    });

    await user.save();
    res.status(201).json({ message: 'User registered successfully', userId });
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: 'Error registering user' });
  }
});

// Login API
app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    // Check if user exists
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ error: 'User not found' });
    }

    // Compare the entered password with the stored hashed password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    // Create and send a JWT token
    const token = jwt.sign({ userId: user.userId }, 'your_jwt_secret', { expiresIn: '1h' });
    res.json({ token, message: 'Login successful', userId: user.userId });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});


// Get User Details by userId
app.get('/api/user/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const user = await User.findOne({ userId });
    if (user) {
      res.json({ name: user.name });
    } else {
      res.status(404).json({ error: 'User not found' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Task Schema
const taskSchema = new mongoose.Schema({
  userId: String, // Associate task with userId
  task: String,
  date: String,
  isCompleted: Boolean,
});

// Create Task model
const Task = mongoose.model('Task', taskSchema);

// Add Task API
app.post('/api/tasks', async (req, res) => {
  const { userId, task, date } = req.body;

  try {
    const newTask = new Task({
      userId, // Add userId to task
      task,
      date,
      isCompleted: false,
    });

    await newTask.save();
    res.status(201).json({ message: 'Task added successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error adding task' });
  }
});

// Fetch Tasks API
app.get('/api/tasks/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const tasks = await Task.find({ userId });
    res.json(tasks);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error fetching tasks' });
  }
});



// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
