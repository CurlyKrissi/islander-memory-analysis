#Install packages
#install.packages("readr")
#install.packages("tidyverse")
#installed.packages("reshape")
#install.packages("ggpubr")

#Import packages
library(tidyverse)
library(readr)
library(reshape2)
library(ggpubr)


# Load dataset
Islander_data <- read_csv("~/Documents/R programming/Elixir course/2025-04-23-R-basic-main/2025-04-23-R-basic-main/data/Islander_data.csv", show_col_types = FALSE)

##Data exploration 

#Print first 10 rows
head(Islander_data, 10)

#Descriptive statistics
summary <- summary(Islander_data)

#Checking for missing values
colSums(is.na(Islander_data))


#Overall average of memory scores before and after the drug was administered
average_memory_score_before <- mean(Islander_data$Mem_Score_Before)
paste('Average before is ' , average_memory_score_before)
average_memory_score_after <- mean(Islander_data$Mem_Score_After)
paste('Average after is ', average_memory_score_after)

t_test_memory_improvment <- t.test(Islander_data$Mem_Score_After,
                                   Islander_data$Mem_Score_Before,
                                   paired = TRUE)
t_test_memory_improvment_A <- t.test(Islander_data$Mem_Score_After[Islander_data$Drug == "A"],
                                   Islander_data$Mem_Score_Before[Islander_data$Drug == "A"],
                                   paired = TRUE)
t_test_memory_improvment_S <- t.test(Islander_data$Mem_Score_After[Islander_data$Drug == "S"],
                                     Islander_data$Mem_Score_Before[Islander_data$Drug == "S"],
                                     paired = TRUE)
t_test_memory_improvment_T <- t.test(Islander_data$Mem_Score_After[Islander_data$Drug == "T"],
                                     Islander_data$Mem_Score_Before[Islander_data$Drug == "T"],
                                     paired = TRUE)

drug_colors <- c("A" = "red", "S" = "green", "T" = "blue")

##Drug analysis 

Islander_data %>% 
  group_by(Drug) %>%  #part 1
  summarize(
    mean_diff = mean(Diff, na.rm = TRUE), #the average diff in memory scores
    median_diff = median(Diff, na.rm = TRUE), #median 
    sd_diff = sd(Diff, na.rm = TRUE) #variance - standard deviation 
)

##Statistics
anova_result <- aov(Diff ~ Drug, data = Islander_data)
summary(anova_result)

pairwise_comparison <- TukeyHSD(anova_result)
pairwise_comparison

##Boxplot: Memory improvment by drug
Memory_improvment_by_drug <- ggplot(Islander_data, aes(x = Drug, y = Diff, fill = Drug)) +
      geom_boxplot(alpha = 0.5) +
      geom_jitter(width = 0.2, alpha = 0.4) +
      theme_minimal() +
      labs(
        title = "Memory Improvement by Drug",
        y = "Memory Score Difference"
      ) + 
  scale_fill_manual(values = drug_colors)
  
Memory_improvment_by_drug

#Save the plot as a PDF file
ggsave(
  filename = "Memory_Improvment_by_Drug.pdf",
  plot = Memory_improvment_by_drug,
  width = 8,
  height = 5
)


##Dosage analysis 

dosage_summary <- Islander_data %>%
  group_by(Drug, Dosage) %>%
  summarise(
    mean_diff = mean(Diff, na.rm = TRUE)
  ) %>%
  arrange(desc(Drug), mean_diff)

dosage_effect <- ggplot(dosage_summary, aes(x = Dosage, y = mean_diff, color = Drug)) +
  geom_line(alpha = 0.5) +
  geom_point(size = 3, alpha = 0.6) +
  facet_wrap(~Drug) +
  theme_minimal() +
  labs(
    title = "Dose–Response Relationship by Drug",
    x = "Dosage",
    y = "Average Memory Improvement"
  ) +
  scale_color_manual(values = drug_colors)
  
dosage_effect 

#Save the plot as a PDF file
ggsave(
  filename = "Dosage_effect.pdf",
  plot = dosage_effect,
  width = 8,
  height = 5
)


##Age group analysis 

#Add new column age_group
Islander_data <- Islander_data %>%
  mutate(
    Age_group = case_when(
      age < 30 ~ 'Young',
      age > 50 ~ 'Senior',
      TRUE ~ 'Middle age'
    ) 
  ) 
  
#Group by Age_group and Drug  
Islander_data %>%
  group_by(Age_group, Drug) %>%
  summarise(
    mean_diff = mean(Diff, na.rm = TRUE)
  ) 

#Visualization: Drug_effect_across_age_group
Drug_effect_across_age_group <- ggplot(Islander_data, aes(x = Age_group, y = Diff, fill = Age_group)) +
  geom_boxplot(alpha = 0.6) +
  facet_wrap(~Drug) +
  theme_minimal() +
  labs(
    title = "Drug Effect Across Age Groups",
    x = "Age Group",
    y = "Memory Score Improvement"
  ) + 
  scale_color_manual(values = drug_colors)
Drug_effect_across_age_group

#Save the plot as a PDF file
ggsave(
  filename = "Drug_effect_across_age_group.pdf",
  plot = Drug_effect_across_age_group,
  width = 8,
  height = 5
)

##State of mood group analysis

mood_summary <- Islander_data %>%
  group_by(Happy_Sad_group) %>%
  summarise(
    mean_diff = mean(Diff, na.rm = TRUE),
    .groups = "drop"
  )

mood_effect <- ggplot(mood_summary, aes(x = Happy_Sad_group, y = mean_diff, fill = Happy_Sad_group)) +
  geom_col(width = 0.6) +
  theme_minimal() +
  scale_fill_manual(values = c(S = "lightblue", H = "lightcoral")) +
  labs(
    title = "Average Memory Improvement by Mood Group",
    x = "Mood Group",
    y = "Average Memory Improvement"
  )
mood_effect

#Save the plot as a PDF file
ggsave(
  filename = "Drug_effect_mood.pdf",
  plot = mood_effect,
  width = 8,
  height = 5
)


#Add column Family
Islander_data <- Islander_data %>%
  mutate(Family = factor(last_name))

#Heatmap: Response to treatment by family and drug
Islander_data_filtered <- Islander_data %>%
  group_by(Family) %>%
  filter(n_distinct(Drug) == 3) %>%  # Assuming 3 unique treatments
  ungroup() 

#Reshape data without aggregation
data_matrix <- dcast(Islander_data_filtered, Family ~ Drug, value.var = "Diff", fun.aggregate = mean)  # using mean or any other aggregation if needed

#Melt the data to long format for plotting
data_long <- melt(data_matrix, id.vars = "Family", variable.name = "Drug", value.name = "Diff")

#Plot the heatmap
Heatmap_TreatmentResponse_ByFamile <- ggplot(data_long, aes(x = Drug, y = Family, fill = Diff)) +
  geom_tile() +
  scale_fill_gradient(low = "lightblue", high = "lightcoral") +
  theme_minimal() +
  labs(x = "Drug", y = "Family", title = "Heatmap of Treatment Response by Family") 

Heatmap_TreatmentResponse_ByFamile

#Save the plot as a PDF file
ggsave(
  filename = "Heatmap_TreatmentResponse_ByFamile.pdf",
  plot = Heatmap_TreatmentResponse_ByFamile,
  width = 8,
  height = 5
)


