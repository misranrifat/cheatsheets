# PyTorch Cheatsheet

## Table of Contents
- [Installation](#installation)
- [Tensors](#tensors)
- [Neural Network Modules](#neural-network-modules)
- [Optimizers](#optimizers)
- [Loss Functions](#loss-functions)
- [Data Loading and Processing](#data-loading-and-processing)
- [Training Loop](#training-loop)
- [Model Saving and Loading](#model-saving-and-loading)
- [GPU Acceleration](#gpu-acceleration)
- [Common Neural Network Architectures](#common-neural-network-architectures)
- [Transfer Learning](#transfer-learning)
- [Distributed Training](#distributed-training)
- [Debugging and Profiling](#debugging-and-profiling)

## Installation

```python
# Install PyTorch with CUDA support
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install CPU-only version
pip install torch torchvision torchaudio

# Verify installation
import torch
print(torch.__version__)
print(torch.cuda.is_available())
```

## Tensors

### Creation

```python
# From Python data
import torch

x = torch.tensor([1, 2, 3])                   # From list
x = torch.tensor([[1, 2], [3, 4]])            # 2D tensor
x = torch.from_numpy(numpy_array)             # From NumPy array

# Common initializations
x = torch.zeros(3, 4)                         # Zeros tensor of shape (3, 4)
x = torch.ones(3, 4)                          # Ones tensor of shape (3, 4)
x = torch.empty(3, 4)                         # Uninitialized tensor
x = torch.rand(3, 4)                          # Random [0, 1) uniform
x = torch.randn(3, 4)                         # Random normal (mean=0, var=1)
x = torch.arange(0, 10, step=1)               # Range from 0 to 9
x = torch.linspace(0, 10, steps=11)           # 11 evenly spaced points
x = torch.eye(3)                              # 3x3 identity matrix
x = torch.diag(torch.tensor([1, 2, 3]))       # Diagonal matrix
```

### Tensor Properties and Manipulation

```python
# Properties
x.shape                                       # Tensor dimensions
x.dtype                                       # Data type
x.device                                      # Device (CPU/GPU)
x.requires_grad                               # For autograd

# Type conversion
x = x.float()                                 # Convert to float32
x = x.double()                                # Convert to float64
x = x.long()                                  # Convert to int64
x = x.int()                                   # Convert to int32
x = x.half()                                  # Convert to float16
x = x.to(dtype=torch.float16)                 # Specific type conversion
x = x.to(device='cuda:0')                     # Move to GPU
x = x.cpu()                                   # Move to CPU
x = x.cuda()                                  # Move to default GPU

# Reshaping
x = x.reshape(2, 6)                           # New shape (2, 6)
x = x.view(3, 4)                              # Similar to reshape but shares data
x = x.squeeze()                               # Remove dimensions of size 1
x = x.unsqueeze(0)                            # Add dimension at index 0
x = x.flatten()                               # Flatten to 1D
x = x.permute(2, 0, 1)                        # Permute dimensions
x = x.transpose(0, 1)                         # Transpose dimensions 0 and 1
```

### Tensor Operations

```python
# Basic operations
z = x + y                                     # Element-wise addition
z = x - y                                     # Element-wise subtraction
z = x * y                                     # Element-wise multiplication
z = x / y                                     # Element-wise division
z = x @ y                                     # Matrix multiplication
z = torch.matmul(x, y)                        # Matrix multiplication
z = x.mm(y)                                   # Matrix multiplication (2D only)
z = torch.add(x, y)                           # Function form of addition

# In-place operations (modifies the tensor)
x.add_(y)                                     # In-place addition
x.sub_(y)                                     # In-place subtraction
x.mul_(y)                                     # In-place multiplication
x.div_(y)                                     # In-place division

# Comparison operations
z = x == y                                    # Element-wise equality
z = x > y                                     # Element-wise greater than
z = torch.eq(x, y)                            # Function form of equality

# Reduction operations
z = x.sum()                                   # Sum of all elements
z = x.sum(dim=0)                              # Sum along dimension 0
z = x.mean()                                  # Mean of all elements
z = x.mean(dim=0, keepdim=True)               # Mean along dim 0, keep dimension
z = x.max()                                   # Maximum value
z = x.argmax(dim=1)                           # Index of maximum along dim 1
z = x.min()                                   # Minimum value
z = x.prod()                                  # Product of all elements

# Other useful operations
z = torch.abs(x)                              # Absolute value
z = torch.sqrt(x)                             # Square root
z = torch.pow(x, 2)                           # Power
z = torch.exp(x)                              # Exponential
z = torch.log(x)                              # Natural logarithm
z = torch.sin(x)                              # Sine
z = torch.cos(x)                              # Cosine
z = torch.clamp(x, min=0, max=1)              # Clamp values to [min, max]
z = torch.cat([x, y], dim=0)                  # Concatenate along dimension
z = torch.stack([x, y], dim=0)                # Stack tensors in new dimension

# Indexing and slicing
z = x[0]                                      # First element or row
z = x[:, 1]                                   # Second column
z = x[2:5, 1:3]                               # Slice from rows 2-4, columns 1-2
z = x[x > 0]                                  # Boolean indexing
indices = torch.tensor([0, 2])
z = torch.index_select(x, dim=0, index=indices) # Select specific indices
```

## Neural Network Modules

### Basic Building Blocks

```python
import torch.nn as nn
import torch.nn.functional as F

# Common layers
linear = nn.Linear(in_features=10, out_features=5)
conv = nn.Conv2d(in_channels=3, out_channels=16, kernel_size=3, stride=1, padding=1)
pool = nn.MaxPool2d(kernel_size=2, stride=2)
dropout = nn.Dropout(p=0.5)
batch_norm = nn.BatchNorm2d(num_features=16)
layer_norm = nn.LayerNorm(normalized_shape=[16, 32, 32])

# Activation functions
relu = nn.ReLU()
leaky_relu = nn.LeakyReLU(negative_slope=0.01)
sigmoid = nn.Sigmoid()
tanh = nn.Tanh()
softmax = nn.Softmax(dim=1)

# Recurrent layers
rnn = nn.RNN(input_size=10, hidden_size=20, num_layers=2, batch_first=True)
lstm = nn.LSTM(input_size=10, hidden_size=20, num_layers=2, batch_first=True)
gru = nn.GRU(input_size=10, hidden_size=20, num_layers=2, batch_first=True)

# Transformer components
multihead_attn = nn.MultiheadAttention(embed_dim=512, num_heads=8)
transformer_encoder_layer = nn.TransformerEncoderLayer(d_model=512, nhead=8)
transformer_encoder = nn.TransformerEncoder(transformer_encoder_layer, num_layers=6)
```

### Creating Neural Networks

```python
# Simple MLP
class MLP(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super(MLP, self).__init__()
        self.fc1 = nn.Linear(input_size, hidden_size)
        self.relu = nn.ReLU()
        self.fc2 = nn.Linear(hidden_size, output_size)
    
    def forward(self, x):
        x = self.fc1(x)
        x = self.relu(x)
        x = self.fc2(x)
        return x

# Simple CNN
class CNN(nn.Module):
    def __init__(self, num_classes=10):
        super(CNN, self).__init__()
        self.conv1 = nn.Conv2d(3, 32, kernel_size=3, padding=1)
        self.bn1 = nn.BatchNorm2d(32)
        self.pool = nn.MaxPool2d(2, 2)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, padding=1)
        self.bn2 = nn.BatchNorm2d(64)
        self.fc1 = nn.Linear(64 * 8 * 8, 128)
        self.fc2 = nn.Linear(128, num_classes)
    
    def forward(self, x):
        x = self.pool(F.relu(self.bn1(self.conv1(x))))
        x = self.pool(F.relu(self.bn2(self.conv2(x))))
        x = x.view(-1, 64 * 8 * 8)
        x = F.relu(self.fc1(x))
        x = self.fc2(x)
        return x

# Sequential model
model = nn.Sequential(
    nn.Conv2d(3, 16, kernel_size=3, padding=1),
    nn.ReLU(),
    nn.MaxPool2d(2, 2),
    nn.Conv2d(16, 32, kernel_size=3, padding=1),
    nn.ReLU(),
    nn.MaxPool2d(2, 2),
    nn.Flatten(),
    nn.Linear(32 * 8 * 8, 128),
    nn.ReLU(),
    nn.Linear(128, 10)
)

# Functional API usage within Module
class FunctionalNet(nn.Module):
    def __init__(self):
        super(FunctionalNet, self).__init__()
        self.conv1 = nn.Conv2d(1, 20, 5)
        self.conv2 = nn.Conv2d(20, 50, 5)
        self.fc1 = nn.Linear(50 * 4 * 4, 500)
        self.fc2 = nn.Linear(500, 10)

    def forward(self, x):
        x = F.relu(F.max_pool2d(self.conv1(x), 2))
        x = F.relu(F.max_pool2d(self.conv2(x), 2))
        x = x.view(-1, 50 * 4 * 4)
        x = F.relu(self.fc1(x))
        x = F.dropout(x, training=self.training)
        x = self.fc2(x)
        return F.log_softmax(x, dim=1)
```

## Optimizers

```python
import torch.optim as optim

# Common optimizers
sgd = optim.SGD(model.parameters(), lr=0.01, momentum=0.9, weight_decay=1e-5)
adam = optim.Adam(model.parameters(), lr=0.001, betas=(0.9, 0.999), eps=1e-8, weight_decay=1e-5)
adamw = optim.AdamW(model.parameters(), lr=0.001, weight_decay=0.01)
rmsprop = optim.RMSprop(model.parameters(), lr=0.01, alpha=0.99)
adagrad = optim.Adagrad(model.parameters(), lr=0.01)

# Learning rate schedulers
scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=30, gamma=0.1)
scheduler = optim.lr_scheduler.MultiStepLR(optimizer, milestones=[30, 80], gamma=0.1)
scheduler = optim.lr_scheduler.ExponentialLR(optimizer, gamma=0.95)
scheduler = optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=100)
scheduler = optim.lr_scheduler.ReduceLROnPlateau(optimizer, mode='min', factor=0.1, patience=10)
scheduler = optim.lr_scheduler.OneCycleLR(optimizer, max_lr=0.01, total_steps=100)
```

## Loss Functions

```python
import torch.nn as nn
import torch.nn.functional as F

# Classification losses
criterion = nn.CrossEntropyLoss()             # Combines LogSoftmax and NLLLoss
criterion = nn.BCELoss()                      # Binary Cross Entropy
criterion = nn.BCEWithLogitsLoss()            # Combines Sigmoid and BCELoss
criterion = nn.NLLLoss()                      # Negative Log Likelihood
criterion = nn.KLDivLoss()                    # Kullback-Leibler Divergence

# Regression losses
criterion = nn.MSELoss()                      # Mean Squared Error
criterion = nn.L1Loss()                       # Mean Absolute Error
criterion = nn.SmoothL1Loss()                 # Smooth L1 Loss (Huber loss)

# Using a loss function
output = model(input)                         # Forward pass
loss = criterion(output, target)              # Compute loss
loss.backward()                               # Compute gradients
optimizer.step()                              # Update weights

# Custom loss with functional API
def custom_loss(output, target):
    return F.mse_loss(output, target) + 0.1 * F.l1_loss(output, target)
```

## Data Loading and Processing

```python
from torch.utils.data import Dataset, DataLoader
import torchvision.transforms as transforms

# Custom dataset
class CustomDataset(Dataset):
    def __init__(self, data, targets, transform=None):
        self.data = data
        self.targets = targets
        self.transform = transform
        
    def __len__(self):
        return len(self.data)
    
    def __getitem__(self, idx):
        x = self.data[idx]
        y = self.targets[idx]
        
        if self.transform:
            x = self.transform(x)
            
        return x, y

# Common transforms
transform = transforms.Compose([
    transforms.ToTensor(),                     # Convert PIL Image to tensor
    transforms.Normalize((0.5,), (0.5,)),      # Normalize with mean and std
    transforms.Resize((224, 224)),             # Resize image
    transforms.RandomCrop(224),                # Random crop
    transforms.RandomHorizontalFlip(),         # Random horizontal flip
    transforms.ColorJitter(brightness=0.2),    # Randomly change brightness
    transforms.RandomRotation(10),             # Random rotation
])

# Using built-in datasets
from torchvision.datasets import MNIST, CIFAR10

train_dataset = MNIST(root='./data', train=True, download=True, transform=transform)
test_dataset = MNIST(root='./data', train=False, download=True, transform=transform)

# DataLoader
train_loader = DataLoader(
    train_dataset,
    batch_size=64,
    shuffle=True,
    num_workers=4,
    pin_memory=True,
    drop_last=False
)

test_loader = DataLoader(
    test_dataset,
    batch_size=128,
    shuffle=False,
    num_workers=4
)
```

## Training Loop

```python
# Basic training loop
def train(model, train_loader, criterion, optimizer, device):
    model.train()  # Set model to training mode
    running_loss = 0.0
    
    for inputs, targets in train_loader:
        inputs, targets = inputs.to(device), targets.to(device)
        
        # Zero the parameter gradients
        optimizer.zero_grad()
        
        # Forward pass
        outputs = model(inputs)
        loss = criterion(outputs, targets)
        
        # Backward pass and optimize
        loss.backward()
        optimizer.step()
        
        running_loss += loss.item()
    
    return running_loss / len(train_loader)

# Evaluation loop
def evaluate(model, test_loader, criterion, device):
    model.eval()  # Set model to evaluation mode
    running_loss = 0.0
    correct = 0
    total = 0
    
    with torch.no_grad():  # Disable gradient computation
        for inputs, targets in test_loader:
            inputs, targets = inputs.to(device), targets.to(device)
            
            # Forward pass
            outputs = model(inputs)
            loss = criterion(outputs, targets)
            
            running_loss += loss.item()
            
            # Calculate accuracy
            _, predicted = torch.max(outputs.data, 1)
            total += targets.size(0)
            correct += (predicted == targets).sum().item()
    
    accuracy = 100 * correct / total
    avg_loss = running_loss / len(test_loader)
    
    return avg_loss, accuracy

# Example of a full training script
def full_training_script(model, train_loader, test_loader, criterion, optimizer, scheduler, device, num_epochs=10):
    best_acc = 0.0
    
    for epoch in range(num_epochs):
        # Train
        train_loss = train(model, train_loader, criterion, optimizer, device)
        
        # Evaluate
        test_loss, test_acc = evaluate(model, test_loader, criterion, device)
        
        # Learning rate scheduler step
        scheduler.step()
        
        # Print statistics
        print(f'Epoch: {epoch+1}/{num_epochs}, Train Loss: {train_loss:.4f}, '
              f'Test Loss: {test_loss:.4f}, Test Acc: {test_acc:.2f}%')
        
        # Save checkpoint if it's the best so far
        if test_acc > best_acc:
            best_acc = test_acc
            torch.save({
                'epoch': epoch,
                'model_state_dict': model.state_dict(),
                'optimizer_state_dict': optimizer.state_dict(),
                'accuracy': test_acc,
            }, 'best_model_checkpoint.pth')
    
    print(f'Best Test Acc: {best_acc:.2f}%')
    return model
```

## Model Saving and Loading

```python
# Saving and loading the entire model
# Saving
torch.save(model, 'model.pth')

# Loading
model = torch.load('model.pth')
model.eval()  # Set to evaluation mode

# Saving and loading model state_dict (recommended)
# Saving
torch.save(model.state_dict(), 'model_state_dict.pth')

# Loading
model = YourModelClass()
model.load_state_dict(torch.load('model_state_dict.pth'))
model.eval()

# Saving and loading a checkpoint
# Saving
checkpoint = {
    'epoch': epoch,
    'model_state_dict': model.state_dict(),
    'optimizer_state_dict': optimizer.state_dict(),
    'loss': loss,
    'accuracy': accuracy,
}
torch.save(checkpoint, 'checkpoint.pth')

# Loading
checkpoint = torch.load('checkpoint.pth')
model.load_state_dict(checkpoint['model_state_dict'])
optimizer.load_state_dict(checkpoint['optimizer_state_dict'])
epoch = checkpoint['epoch']
loss = checkpoint['loss']
```

## GPU Acceleration

```python
# Check GPU availability
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f'Using device: {device}')

# Get number of available GPUs
num_gpus = torch.cuda.device_count()
print(f'Number of GPUs: {num_gpus}')

# Get current GPU
current_gpu = torch.cuda.current_device()
print(f'Current GPU: {current_gpu}')

# Get GPU name
if torch.cuda.is_available():
    print(f'GPU Name: {torch.cuda.get_device_name(0)}')

# Move model to device
model = model.to(device)

# Move tensors to device
x = x.to(device)
y = y.to(device)

# Create tensor directly on device
x = torch.rand(3, 4, device=device)

# Use multiple GPUs with DataParallel
if torch.cuda.device_count() > 1:
    print(f"Using {torch.cuda.device_count()} GPUs")
    model = nn.DataParallel(model)
model = model.to(device)

# Use specific GPU
torch.cuda.set_device(1)  # Use GPU 1
x = torch.cuda.FloatTensor(1)  # x is on GPU 1

# Memory management
torch.cuda.empty_cache()  # Free up GPU memory cache
```

## Common Neural Network Architectures

```python
# ResNet Block
class ResBlock(nn.Module):
    def __init__(self, in_channels, out_channels, stride=1):
        super(ResBlock, self).__init__()
        self.conv1 = nn.Conv2d(in_channels, out_channels, kernel_size=3, 
                              stride=stride, padding=1, bias=False)
        self.bn1 = nn.BatchNorm2d(out_channels)
        self.conv2 = nn.Conv2d(out_channels, out_channels, kernel_size=3,
                              stride=1, padding=1, bias=False)
        self.bn2 = nn.BatchNorm2d(out_channels)
        
        self.shortcut = nn.Sequential()
        if stride != 1 or in_channels != out_channels:
            self.shortcut = nn.Sequential(
                nn.Conv2d(in_channels, out_channels, kernel_size=1, 
                         stride=stride, bias=False),
                nn.BatchNorm2d(out_channels)
            )
            
    def forward(self, x):
        out = F.relu(self.bn1(self.conv1(x)))
        out = self.bn2(self.conv2(out))
        out += self.shortcut(x)
        out = F.relu(out)
        return out

# Simplified ResNet
class SimpleResNet(nn.Module):
    def __init__(self, num_classes=10):
        super(SimpleResNet, self).__init__()
        self.in_channels = 64
        
        self.conv1 = nn.Conv2d(3, 64, kernel_size=3, stride=1, padding=1, bias=False)
        self.bn1 = nn.BatchNorm2d(64)
        
        self.layer1 = self._make_layer(64, 2, stride=1)
        self.layer2 = self._make_layer(128, 2, stride=2)
        self.layer3 = self._make_layer(256, 2, stride=2)
        
        self.avg_pool = nn.AdaptiveAvgPool2d((1, 1))
        self.fc = nn.Linear(256, num_classes)
        
    def _make_layer(self, out_channels, num_blocks, stride):
        strides = [stride] + [1] * (num_blocks - 1)
        layers = []
        for stride in strides:
            layers.append(ResBlock(self.in_channels, out_channels, stride))
            self.in_channels = out_channels
        return nn.Sequential(*layers)
    
    def forward(self, x):
        out = F.relu(self.bn1(self.conv1(x)))
        
        out = self.layer1(out)
        out = self.layer2(out)
        out = self.layer3(out)
        
        out = self.avg_pool(out)
        out = out.view(out.size(0), -1)
        out = self.fc(out)
        return out

# U-Net Block (for segmentation)
class UNetBlock(nn.Module):
    def __init__(self, in_channels, out_channels):
        super(UNetBlock, self).__init__()
        self.conv1 = nn.Conv2d(in_channels, out_channels, kernel_size=3, padding=1)
        self.bn1 = nn.BatchNorm2d(out_channels)
        self.conv2 = nn.Conv2d(out_channels, out_channels, kernel_size=3, padding=1)
        self.bn2 = nn.BatchNorm2d(out_channels)
        
    def forward(self, x):
        x = F.relu(self.bn1(self.conv1(x)))
        x = F.relu(self.bn2(self.conv2(x)))
        return x

# LSTM for sequence modeling
class LSTMModel(nn.Module):
    def __init__(self, input_size, hidden_size, num_layers, output_size):
        super(LSTMModel, self).__init__()
        self.hidden_size = hidden_size
        self.num_layers = num_layers
        
        self.lstm = nn.LSTM(input_size, hidden_size, num_layers, batch_first=True)
        self.fc = nn.Linear(hidden_size, output_size)
        
    def forward(self, x):
        # x shape: (batch_size, sequence_length, input_size)
        h0 = torch.zeros(self.num_layers, x.size(0), self.hidden_size).to(x.device)
        c0 = torch.zeros(self.num_layers, x.size(0), self.hidden_size).to(x.device)
        
        # Forward propagate LSTM
        out, _ = self.lstm(x, (h0, c0))  # out: (batch_size, seq_length, hidden_size)
        
        # Decode the hidden state of the last time step
        out = self.fc(out[:, -1, :])
        return out

# Simple Transformer Encoder
class SimpleTransformer(nn.Module):
    def __init__(self, vocab_size, d_model, nhead, num_encoder_layers, dim_feedforward, max_seq_length, num_classes):
        super(SimpleTransformer, self).__init__()
        self.embedding = nn.Embedding(vocab_size, d_model)
        self.pos_encoder = nn.Parameter(torch.zeros(max_seq_length, d_model))
        
        encoder_layers = nn.TransformerEncoderLayer(d_model=d_model, nhead=nhead, 
                                                 dim_feedforward=dim_feedforward)
        self.transformer_encoder = nn.TransformerEncoder(encoder_layers, num_layers=num_encoder_layers)
        
        self.fc = nn.Linear(d_model, num_classes)
        
    def forward(self, x):
        # x shape: (batch_size, seq_length)
        seq_length = x.size(1)
        
        # Add positional encoding
        x = self.embedding(x)  # (batch_size, seq_length, d_model)
        x = x + self.pos_encoder[:seq_length, :]
        
        # Transformer expects: (seq_length, batch_size, d_model)
        x = x.permute(1, 0, 2)
        
        # Transform
        x = self.transformer_encoder(x)
        
        # Use the output of the last token
        x = x[-1]  # (batch_size, d_model)
        
        # Classification
        x = self.fc(x)
        return x
```

## Transfer Learning

```python
import torchvision.models as models

# Load a pretrained model
resnet = models.resnet50(pretrained=True)
vgg16 = models.vgg16(pretrained=True)
mobilenet = models.mobilenet_v2(pretrained=True)
efficientnet = models.efficientnet_b0(pretrained=True)

# Freeze parameters
for param in resnet.parameters():
    param.requires_grad = False

# Modify the final layer for your specific task
num_features = resnet.fc.in_features
resnet.fc = nn.Linear(num_features, num_classes)

# Alternatively, replace multiple layers
resnet.fc = nn.Sequential(
    nn.Linear(num_features, 512),
    nn.ReLU(),
    nn.Dropout(0.5),
    nn.Linear(512, num_classes)
)

# Feature extraction example
class FeatureExtractor(nn.Module):
    def __init__(self, pretrained_model, feature_layer):
        super(FeatureExtractor, self).__init__()
        self.features = nn.Sequential(
            *list(pretrained_model.children())[:feature_layer]
        )
        
    def forward(self, x):
        return self.features(x)

# Example: Extract features from ResNet's 4th layer
extractor = FeatureExtractor(resnet, 4)
features = extractor(input_image)
```

## Distributed Training

```python
import torch.distributed as dist
import torch.multiprocessing as mp
from torch.nn.parallel import DistributedDataParallel as DDP

# Initialize process group
def setup(rank, world_size):
    os.environ['MASTER_ADDR'] = 'localhost'
    os.environ['MASTER_PORT'] = '12355'
    dist.init_process_group("nccl", rank=rank, world_size=world_size)

# Clean up
def cleanup():
    dist.destroy_process_group()

# Training function for each process
def train_process(rank, world_size):
    setup(rank, world_size)
    
    # Create model and move it to GPU with id rank
    model = YourModel().to(rank)
    model = DDP(model, device_ids=[rank])
    
    # DistributedSampler for training data
    train_sampler = torch.utils.data.distributed.DistributedSampler(
        train_dataset,
        num_replicas=world_size,
        rank=rank
    )
    
    train_loader = DataLoader(
        train_dataset,
        batch_size=batch_size,
        sampler=train_sampler,
        num_workers=4,
        pin_memory=True
    )
    
    # Training loop
    for epoch in range(num_epochs):
        train_sampler.set_epoch(epoch)
        # ... rest of training code
    
    cleanup()

# Launch training processes
def main():
    world_size = torch.cuda.device_count()
    mp.spawn(train_process,
             args=(world_size,),
             nprocs=world_size,
             join=True)
```

## Debugging and Profiling

```python
# Check gradients (continued)
x = torch.randn(1, 3, 224, 224, requires_grad=True)
output = model(x)
output.backward()
for name, param in model.named_parameters():
    if param.grad is not None:
        print(f"{name} - grad shape: {param.grad.shape}, grad mean: {param.grad.mean()}")
    else:
        print(f"{name} - no grad")

# Detect NaN values
def detect_anomaly(x, name):
    if torch.isnan(x).any():
        print(f"NaN detected in {name}")
    if torch.isinf(x).any():
        print(f"Inf detected in {name}")

# Enable anomaly detection for autograd
torch.autograd.set_detect_anomaly(True)

# Memory profiling
print(f"Max memory allocated: {torch.cuda.max_memory_allocated() / 1e6} MB")
print(f"Max memory cached: {torch.cuda.max_memory_cached() / 1e6} MB")
torch.cuda.reset_peak_memory_stats()  # Reset stats

# Simple profiling with time
import time
start_time = time.time()
# ... code to profile
end_time = time.time()
print(f"Execution time: {end_time - start_time:.2f} seconds")

# PyTorch built-in profiler
from torch.profiler import profile, record_function, ProfilerActivity

with profile(activities=[ProfilerActivity.CPU, ProfilerActivity.CUDA],
             record_shapes=True) as prof:
    with record_function("model_inference"):
        output = model(input)

print(prof.key_averages().table(sort_by="cuda_time_total", row_limit=10))

# Export profiling results for visualization
prof.export_chrome_trace("trace.json")
```

## PyTorch Lightning (High-level Framework)

```python
import pytorch_lightning as pl
from pytorch_lightning.callbacks import ModelCheckpoint, EarlyStopping

# PyTorch Lightning Module
class LightningModel(pl.LightningModule):
    def __init__(self):
        super().__init__()
        self.model = YourModel()
        self.criterion = nn.CrossEntropyLoss()
        
    def forward(self, x):
        return self.model(x)
    
    def training_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self(x)
        loss = self.criterion(y_hat, y)
        self.log('train_loss', loss)
        return loss
    
    def validation_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self(x)
        loss = self.criterion(y_hat, y)
        self.log('val_loss', loss)
        
    def test_step(self, batch, batch_idx):
        x, y = batch
        y_hat = self(x)
        loss = self.criterion(y_hat, y)
        self.log('test_loss', loss)
        
    def configure_optimizers(self):
        optimizer = torch.optim.Adam(self.parameters(), lr=1e-3)
        scheduler = torch.optim.lr_scheduler.ReduceLROnPlateau(
            optimizer, mode='min', factor=0.1, patience=10
        )
        return {
            'optimizer': optimizer,
            'lr_scheduler': scheduler,
            'monitor': 'val_loss'
        }

# Train with Lightning
model = LightningModel()

checkpoint_callback = ModelCheckpoint(
    monitor='val_loss',
    dirpath='./checkpoints',
    filename='model-{epoch:02d}-{val_loss:.2f}',
    save_top_k=3,
    mode='min',
)

early_stop_callback = EarlyStopping(
    monitor='val_loss',
    patience=5,
    verbose=True,
    mode='min'
)

trainer = pl.Trainer(
    max_epochs=10,
    gpus=1,
    callbacks=[checkpoint_callback, early_stop_callback],
    progress_bar_refresh_rate=20,
)

trainer.fit(model, train_loader, val_loader)
trainer.test(test_dataloaders=test_loader)
```

## TorchScript for Deployment

```python
# Convert model to TorchScript via tracing
example_input = torch.rand(1, 3, 224, 224)
traced_model = torch.jit.trace(model, example_input)

# Convert model to TorchScript via scripting
scripted_model = torch.jit.script(model)

# Save the TorchScript model
traced_model.save("traced_model.pt")
scripted_model.save("scripted_model.pt")

# Load the TorchScript model
loaded_model = torch.jit.load("traced_model.pt")

# Inference with TorchScript model
with torch.no_grad():
    output = loaded_model(input)
```

## Quantization

```python
# Post-training static quantization
model_fp32 = YourModel()
model_fp32.load_state_dict(torch.load("model_weights.pth"))
model_fp32.eval()

# Define quantization configuration
model_fp32.qconfig = torch.quantization.get_default_qconfig('fbgemm')  # for x86
# or 'qnnpack' for ARM

# Prepare model for quantization
model_prepared = torch.quantization.prepare(model_fp32)

# Calibrate with data (feed examples through the network)
with torch.no_grad():
    for data, _ in calibration_loader:
        model_prepared(data)

# Convert to quantized model
model_int8 = torch.quantization.convert(model_prepared)

# Quantization-aware training
from torch.quantization import QuantStub, DeQuantStub

class QuantizationAwareModel(nn.Module):
    def __init__(self):
        super(QuantizationAwareModel, self).__init__()
        self.quant = QuantStub()
        self.dequant = DeQuantStub()
        self.model = YourModel()
        
    def forward(self, x):
        x = self.quant(x)
        x = self.model(x)
        x = self.dequant(x)
        return x

# Set qconfig for QAT
qat_model = QuantizationAwareModel()
qat_model.qconfig = torch.quantization.get_default_qat_qconfig('fbgemm')

# Prepare QAT
torch.quantization.prepare_qat(qat_model, inplace=True)

# Train the model (QAT)
# ...

# Convert to quantized model
quantized_model = torch.quantization.convert(qat_model.eval(), inplace=False)
```

## Mixed Precision Training

```python
# Using torch.cuda.amp (Automatic Mixed Precision)
from torch.cuda.amp import autocast, GradScaler

# Create gradient scaler
scaler = GradScaler()

# Training loop with mixed precision
for inputs, targets in train_loader:
    inputs, targets = inputs.to(device), targets.to(device)
    
    # Zero gradients
    optimizer.zero_grad()
    
    # Forward pass with autocast
    with autocast():
        outputs = model(inputs)
        loss = criterion(outputs, targets)
    
    # Backward pass with scaler
    scaler.scale(loss).backward()
    scaler.step(optimizer)
    scaler.update()
```

## Custom CUDA Extensions

```python
# Setup file (setup.py) for custom CUDA extension
from setuptools import setup
from torch.utils.cpp_extension import BuildExtension, CUDAExtension

setup(
    name='custom_kernel',
    ext_modules=[
        CUDAExtension('custom_kernel', [
            'custom_kernel.cpp',
            'custom_kernel_cuda.cu',
        ]),
    ],
    cmdclass={
        'build_ext': BuildExtension
    }
)

# Build the extension
# pip install -e .

# Use in Python
import torch
import custom_kernel

result = custom_kernel.forward(input_tensor)
```

## Advanced Tips and Tricks

### Memory Optimization

```python
# Use inplace operations where possible
x = torch.relu_(x)  # Inplace ReLU

# Clear unused variables
del unused_tensor
torch.cuda.empty_cache()

# Use checkpoint to trade computation for memory
from torch.utils.checkpoint import checkpoint

def forward_with_checkpoint(self, x):
    x = checkpoint(self.block1, x)  # Saves memory by not storing activations
    x = checkpoint(self.block2, x)
    return x

# Use 16-bit precision when possible
model = model.half()  # Convert model to half precision
inputs = inputs.half()  # Convert inputs to half precision

# Use gradient accumulation for large batches
optimizer.zero_grad()
for i, (inputs, targets) in enumerate(train_loader):
    outputs = model(inputs)
    loss = criterion(outputs, targets) / accumulation_steps
    loss.backward()
    
    if (i + 1) % accumulation_steps == 0:
        optimizer.step()
        optimizer.zero_grad()
```

### Performance Tips

```python
# Set the number of threads for CPU operations
torch.set_num_threads(4)  # Use 4 CPU threads

# Pin memory for faster GPU transfer
train_loader = DataLoader(dataset, batch_size=32, pin_memory=True)

# Use non-blocking transfers
x = x.to(device, non_blocking=True)

# Use cudnn benchmarking for consistent input sizes
torch.backends.cudnn.benchmark = True

# Disable cudnn benchmarking for variable input sizes
torch.backends.cudnn.benchmark = False

# Ensure deterministic behavior (slower)
torch.backends.cudnn.deterministic = True
torch.manual_seed(42)
```

### Debugging NaNs

```python
# Register hooks to detect NaNs during forward pass
def hook_fn(module, input, output):
    if torch.isnan(output).any():
        print(f"NaN detected in output of {module}")
        raise RuntimeError("NaN detected")

for name, module in model.named_modules():
    module.register_forward_hook(hook_fn)

# Track gradient flow for debugging
def plot_grad_flow(named_parameters):
    import matplotlib.pyplot as plt
    import numpy as np
    
    ave_grads = []
    layers = []
    for n, p in named_parameters:
        if p.requires_grad and ("bias" not in n) and p.grad is not None:
            layers.append(n)
            ave_grads.append(p.grad.abs().mean().item())
    plt.figure(figsize=(10, 8))
    plt.bar(np.arange(len(ave_grads)), ave_grads, alpha=0.5, lw=1, color="b")
    plt.hlines(0, 0, len(ave_grads)+1, lw=2, color="k" )
    plt.xticks(range(0,len(ave_grads), 1), layers, rotation="vertical")
    plt.xlim(left=0, right=len(ave_grads))
    plt.xlabel("Layers")
    plt.ylabel("Average gradient")
    plt.title("Gradient flow")
    plt.grid(True)
    plt.savefig("gradient_flow.png")
```

## Hugging Face Integration

```python
from transformers import AutoModel, AutoTokenizer
import torch

# Load pretrained model and tokenizer
tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")
model = AutoModel.from_pretrained("bert-base-uncased")

# Tokenize input text
inputs = tokenizer("Hello world!", return_tensors="pt")

# Get model outputs
with torch.no_grad():
    outputs = model(**inputs)

# Access hidden states
last_hidden_state = outputs.last_hidden_state

# Fine-tuning with PyTorch
from transformers import AutoModelForSequenceClassification

# Load model for fine-tuning
model = AutoModelForSequenceClassification.from_pretrained(
    "bert-base-uncased", num_labels=2
)

# Training loop
optimizer = torch.optim.AdamW(model.parameters(), lr=5e-5)

for batch in train_dataloader:
    inputs = {k: v.to(device) for k, v in batch.items() if k != "labels"}
    labels = batch["labels"].to(device)
    
    outputs = model(**inputs, labels=labels)
    loss = outputs.loss
    
    loss.backward()
    optimizer.step()
    optimizer.zero_grad()

# Save fine-tuned model
model.save_pretrained("./fine_tuned_model")
tokenizer.save_pretrained("./fine_tuned_model")
```

## Working with Audio and Speech

```python
import torchaudio
import torchaudio.transforms as T

# Load audio file
waveform, sample_rate = torchaudio.load("audio.wav")

# Resample audio
resample = T.Resample(orig_freq=sample_rate, new_freq=16000)
waveform = resample(waveform)

# Create spectrogram
spectrogram = T.Spectrogram()(waveform)

# Create mel spectrogram
mel_spectrogram = T.MelSpectrogram(sample_rate=16000)(waveform)

# Apply MFCC
mfcc = T.MFCC(sample_rate=16000)(waveform)

# Time stretching
stretch = T.TimeStretch()(spectrogram)

# Audio augmentation
augment = torch.nn.Sequential(
    T.FrequencyMasking(freq_mask_param=30),
    T.TimeMasking(time_mask_param=100)
)
augmented_spectrogram = augment(spectrogram)
```

## Working with Images and Vision

```python
import torchvision
import torchvision.transforms.functional as F

# Load image
from PIL import Image
img = Image.open("image.jpg")

# Convert to tensor
img_tensor = F.to_tensor(img)

# Common image transformations
img_normalized = F.normalize(img_tensor, mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
img_resized = F.resize(img_tensor, size=[224, 224])
img_cropped = F.center_crop(img_tensor, output_size=[224, 224])
img_flipped = F.hflip(img_tensor)
img_rotated = F.rotate(img_tensor, angle=45)

# Image augmentations with Kornia
import kornia as K
import kornia.augmentation as KA

aug = KA.AugmentationSequential(
    KA.RandomResizedCrop((224, 224), scale=(0.8, 1.0), ratio=(3/4, 4/3)),
    KA.RandomHorizontalFlip(p=0.5),
    KA.ColorJitter(brightness=0.1, contrast=0.1, saturation=0.1, hue=0.1),
    KA.RandomGrayscale(p=0.2),
    data_keys=["input"]
)

augmented = aug(img_tensor.unsqueeze(0))  # Add batch dimension
```

## Reinforcement Learning with PyTorch

```python
import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np

# Define a simple policy network
class PolicyNetwork(nn.Module):
    def __init__(self, state_dim, action_dim):
        super(PolicyNetwork, self).__init__()
        self.fc1 = nn.Linear(state_dim, 128)
        self.fc2 = nn.Linear(128, 64)
        self.fc3 = nn.Linear(64, action_dim)
        
    def forward(self, x):
        x = torch.relu(self.fc1(x))
        x = torch.relu(self.fc2(x))
        x = torch.softmax(self.fc3(x), dim=-1)
        return x

# REINFORCE algorithm (simple policy gradient)
def train_reinforce(env, policy, optimizer, gamma=0.99, num_episodes=1000):
    for episode in range(num_episodes):
        state = env.reset()
        log_probs = []
        rewards = []
        done = False
        
        while not done:
            state_tensor = torch.FloatTensor(state).unsqueeze(0)
            action_probs = policy(state_tensor)
            
            # Sample action from the probability distribution
            dist = torch.distributions.Categorical(action_probs)
            action = dist.sample()
            log_prob = dist.log_prob(action)
            
            # Take action in the environment
            next_state, reward, done, _ = env.step(action.item())
            
            log_probs.append(log_prob)
            rewards.append(reward)
            state = next_state
        
        # Calculate returns
        returns = []
        G = 0
        for reward in reversed(rewards):
            G = reward + gamma * G
            returns.insert(0, G)
        returns = torch.FloatTensor(returns)
        
        # Normalize returns for stability (optional)
        returns = (returns - returns.mean()) / (returns.std() + 1e-9)
        
        # Calculate loss
        loss = 0
        for log_prob, G in zip(log_probs, returns):
            loss -= log_prob * G
        
        # Update policy
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
        if episode % 10 == 0:
            print(f"Episode {episode}, Loss: {loss.item()}")
```

## TorchServe for Model Deployment

```python
# Create model archive file (model.mar)
# Requires installing torch-model-archiver
# torch-model-archiver --model-name my_model --version 1.0 --model-file model.py \
#                     --serialized-file model.pth --handler image_classifier

# Config file (config.properties)
"""
inference_address=http://0.0.0.0:8080
management_address=http://0.0.0.0:8081
metrics_address=http://0.0.0.0:8082
number_of_netty_threads=32
job_queue_size=1000
model_store=/path/to/model/store
"""

# Start TorchServe
# torchserve --start --model-store model_store --models my_model=my_model.mar

# Make API call to deployed model
import requests
response = requests.post("http://localhost:8080/predictions/my_model", 
                        files={"data": open("image.jpg", "rb")})
print(response.json())

# Stop TorchServe
# torchserve --stop
```

## ONNX Export and Interoperability

```python
import torch.onnx

# Export model to ONNX
dummy_input = torch.randn(1, 3, 224, 224)
torch.onnx.export(model,                       # Model being exported
                 dummy_input,                  # Example input
                 "model.onnx",                 # Output file name
                 export_params=True,           # Export model parameters
                 opset_version=11,             # ONNX version
                 do_constant_folding=True,     # Constant folding optimization
                 input_names=["input"],        # Input names
                 output_names=["output"],      # Output names
                 dynamic_axes={"input": {0: "batch_size"},  # Dynamic dimensions
                              "output": {0: "batch_size"}})

# Load and verify ONNX model
import onnx
onnx_model = onnx.load("model.onnx")
onnx.checker.check_model(onnx_model)

# Run ONNX model with ONNX Runtime
import onnxruntime as ort
ort_session = ort.InferenceSession("model.onnx")

# Run inference
ort_inputs = {ort_session.get_inputs()[0].name: dummy_input.numpy()}
ort_outputs = ort_session.run(None, ort_inputs)

# Compare PyTorch and ONNX Runtime outputs
torch_output = model(dummy_input).detach().numpy()
np.testing.assert_allclose(torch_output, ort_outputs[0], rtol=1e-03, atol=1e-05)
```

## Useful Utilities

```python
# One-hot encoding
def one_hot(x, num_classes):
    return torch.eye(num_classes)[x]

# Convert between NumPy and PyTorch
numpy_array = torch_tensor.detach().cpu().numpy()
torch_tensor = torch.from_numpy(numpy_array).to(device)

# Concatenate tensors along dimension
torch.cat([tensor1, tensor2], dim=0)

# Stack tensors in new dimension
torch.stack([tensor1, tensor2], dim=0)

# Split tensor into chunks
chunks = torch.chunk(tensor, chunks=3, dim=0)

# Get top-k values and indices
values, indices = torch.topk(tensor, k=5, dim=1)

# Compute confusion matrix
def confusion_matrix(y_true, y_pred, num_classes):
    cm = torch.zeros(num_classes, num_classes, dtype=torch.long)
    for i in range(y_true.size(0)):
        cm[y_true[i], y_pred[i]] += 1
    return cm

# Save and load checkpoint with best validation accuracy
def save_checkpoint(state, is_best, filename='checkpoint.pth.tar'):
    torch.save(state, filename)
    if is_best:
        shutil.copyfile(filename, 'model_best.pth.tar')

# Calculate precision, recall, and F1 score
def calculate_metrics(y_true, y_pred):
    true_positives = (y_true * y_pred).sum().item()
    predicted_positives = y_pred.sum().item()
    actual_positives = y_true.sum().item()
    
    precision = true_positives / predicted_positives if predicted_positives > 0 else 0
    recall = true_positives / actual_positives if actual_positives > 0 else 0
    f1 = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0
    
    return precision, recall, f1
```

## Resources and References

### Official Documentation
- [PyTorch Official Documentation](https://pytorch.org/docs/stable/index.html)
- [PyTorch Tutorials](https://pytorch.org/tutorials/)
- [PyTorch Examples](https://github.com/pytorch/examples)
- [TorchVision Documentation](https://pytorch.org/vision/stable/index.html)
- [PyTorch Lightning Documentation](https://pytorch-lightning.readthedocs.io/)

### Community Resources
- [PyTorch Discussion Forum](https://discuss.pytorch.org/)
- [PyTorch Github Repository](https://github.com/pytorch/pytorch)
- [Awesome PyTorch (GitHub)](https://github.com/bharathgs/Awesome-pytorch-list)

### Books and Courses
- "Deep Learning with PyTorch" by Eli Stevens, Luca Antiga, and Thomas Viehmann
- "Programming PyTorch for Deep Learning" by Ian Pointer
- "PyTorch Recipes" by Pradeepta Mishra
- "Fast.ai Practical Deep Learning for Coders"
